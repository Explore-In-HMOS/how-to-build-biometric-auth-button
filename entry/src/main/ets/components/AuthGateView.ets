import { UserAuthIcon, UserAuthIconConfig, AuthIconType } from './UserAuthIcon';
import { HealthDataView } from './HealthDataView';
import { AuthState } from '../common/AuthState';
import { sessionGuard } from '../common/SessionGuard';

@Component
export struct AuthGateView {
  @State private authState: AuthState = AuthState.LOCKED;

  aboutToAppear(): void {
    sessionGuard.onLockRequested((): void => {
      this.authState = AuthState.LOCKED;
    });
  }

  private authIconConfig(): UserAuthIconConfig {
    return {
      size: 48,
      color: $r('app.color.auth_icon_color'),
      authTypePreference: AuthIconType.FACE,
      onSuccess: (): void => {
        this.authState = AuthState.UNLOCKED;
        sessionGuard.resetInactivityTimer();
      },
      onFail: (): void => {
        this.authState = AuthState.FAILED;
      },
      onCancel: (): void => {
        this.authState = AuthState.LOCKED;
      }
    };
  }

  build() {
    Column({ space: 12 }) {
      if (this.authState === AuthState.UNLOCKED) {
        HealthDataView()
      } else {
        Column({ space: 12 }) {
          UserAuthIcon({ config: this.authIconConfig() })

          if (this.authState === AuthState.FAILED) {
            Text($r('app.string.auth_failed_hint'))
              .fontSize(12)
              .fontColor($r('app.color.auth_failed_color'))
          } else {
            Text($r('app.string.auth_locked_hint'))
              .fontSize(12)
              .fontColor($r('app.color.panel_title_color'))
          }
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }
}
