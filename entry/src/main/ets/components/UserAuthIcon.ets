import userIAM_userAuth from '@ohos.userIAM.userAuth';

// userAuthIcon module: configuration and styling for the UserAuthIcon component below
// (size, color, auth type preference, callback handlers).
export enum AuthIconType {
  FINGERPRINT = 'FINGERPRINT',
  FACE = 'FACE',
  PIN = 'PIN'
}

export interface UserAuthIconConfig {
  size?: number;
  color?: ResourceColor;
  authTypePreference?: AuthIconType;
  onSuccess?: () => void;
  onFail?: (reason: string) => void;
  onCancel?: () => void;
}

export function defaultUserAuthIconConfig(): UserAuthIconConfig {
  return {
    size: 48,
    color: $r('app.color.auth_icon_color'),
    authTypePreference: AuthIconType.FACE
  };
}

const AUTH_CHALLENGE: Uint8Array = new Uint8Array([1, 2, 3, 4, 5, 6]);

// UserAuthIcon component: renders the system-provided biometric authentication icon
// (fingerprint, face, PIN badge) and owns the tap-triggered system authentication flow.
@Component
export struct UserAuthIcon {
  config: UserAuthIconConfig = defaultUserAuthIconConfig();
  @State private resolvedType: AuthIconType = AuthIconType.PIN;
  @State private isAuthenticating: boolean = false;

  aboutToAppear(): void {
    this.resolvedType = this.detectAvailableAuthType();
  }

  private iconColor(): ResourceColor {
    return this.config.color ?? $r('app.color.auth_icon_color');
  }

  private iconSize(): number {
    return this.config.size ?? 48;
  }

  private toSystemAuthType(type: AuthIconType): number {
    if (type === AuthIconType.FACE) {
      return userIAM_userAuth.UserAuthType.FACE;
    }
    if (type === AuthIconType.FINGERPRINT) {
      return userIAM_userAuth.UserAuthType.FINGERPRINT;
    }
    return userIAM_userAuth.UserAuthType.PIN;
  }

  // Auto auth-method adaptation (R2): probe FACE, then FINGERPRINT, falling back to PIN
  // which is always available on-device.
  private detectAvailableAuthType(): AuthIconType {
    const preference: AuthIconType = this.config.authTypePreference ?? AuthIconType.FACE;
    const probeOrder: AuthIconType[] = preference === AuthIconType.FINGERPRINT
      ? [AuthIconType.FINGERPRINT, AuthIconType.FACE]
      : [AuthIconType.FACE, AuthIconType.FINGERPRINT];

    for (let i = 0; i < probeOrder.length; i++) {
      const candidate: AuthIconType = probeOrder[i];
      try {
        userIAM_userAuth.getAvailableStatus(this.toSystemAuthType(candidate), userIAM_userAuth.AuthTrustLevel.ATL1);
        return candidate;
      } catch (error) {
        // candidate not enrolled/available, try next
      }
    }
    return AuthIconType.PIN;
  }

  private startAuthentication(): void {
    if (this.isAuthenticating) {
      return;
    }
    this.isAuthenticating = true;

    const authParam: userIAM_userAuth.AuthParam = {
      challenge: AUTH_CHALLENGE,
      authType: [this.toSystemAuthType(this.resolvedType), userIAM_userAuth.UserAuthType.PIN],
      authTrustLevel: userIAM_userAuth.AuthTrustLevel.ATL1
    };
    const widgetParam: userIAM_userAuth.WidgetParam = {
      title: this.getUIContext().getHostContext()!.resourceManager.getStringSync($r('app.string.auth_locked_hint').id)
    };

    try {
      const authInstance = userIAM_userAuth.getUserAuthInstance(authParam, widgetParam);
      authInstance.on('result', {
        onResult: (result: userIAM_userAuth.UserAuthResult): void => {
          this.isAuthenticating = false;
          if (result.result === userIAM_userAuth.UserAuthResultCode.SUCCESS) {
            if (this.config.onSuccess) {
              this.config.onSuccess();
            }
          } else if (result.result === userIAM_userAuth.UserAuthResultCode.CANCELED) {
            if (this.config.onCancel) {
              this.config.onCancel();
            }
          } else {
            if (this.config.onFail) {
              this.config.onFail(`resultCode:${result.result}`);
            }
          }
        }
      });
      authInstance.start();
    } catch (error) {
      this.isAuthenticating = false;
      if (this.config.onFail) {
        this.config.onFail(JSON.stringify(error));
      }
    }
  }

  build() {
    Stack() {
      Circle()
        .width(this.iconSize())
        .height(this.iconSize())
        .fill(Color.Transparent)
        .stroke(this.iconColor())
        .strokeWidth(2)

      if (this.resolvedType === AuthIconType.FACE) {
        this.FaceGlyph()
      } else if (this.resolvedType === AuthIconType.FINGERPRINT) {
        this.FingerprintGlyph()
      } else {
        this.PinGlyph()
      }
    }
    .width(this.iconSize())
    .height(this.iconSize())
    .opacity(this.isAuthenticating ? 0.5 : 1)
    .onClick((): void => this.startAuthentication())
  }

  @Builder
  FingerprintGlyph() {
    Stack() {
      Circle().width('90%').height('90%').fill(Color.Transparent).stroke(this.iconColor()).strokeWidth(1.5)
      Circle().width('62%').height('62%').fill(Color.Transparent).stroke(this.iconColor()).strokeWidth(1.5)
      Circle().width('34%').height('34%').fill(Color.Transparent).stroke(this.iconColor()).strokeWidth(1.5)
    }
  }

  @Builder
  FaceGlyph() {
    Column({ space: 6 }) {
      Row({ space: 10 }) {
        Circle().width(5).height(5).fill(this.iconColor())
        Circle().width(5).height(5).fill(this.iconColor())
      }

      Line()
        .width(14)
        .height(4)
        .startPoint([0, 0])
        .endPoint([14, 0])
        .stroke(this.iconColor())
        .strokeWidth(2)
        .strokeLineCap(LineCapStyle.Round)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  PinGlyph() {
    Column({ space: 4 }) {
      Row({ space: 4 }) {
        Circle().width(4).height(4).fill(this.iconColor())
        Circle().width(4).height(4).fill(this.iconColor())
        Circle().width(4).height(4).fill(this.iconColor())
      }
      Row({ space: 4 }) {
        Circle().width(4).height(4).fill(this.iconColor())
        Circle().width(4).height(4).fill(this.iconColor())
        Circle().width(4).height(4).fill(this.iconColor())
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
