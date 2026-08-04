type LockListener = () => void;

class SessionGuardImpl {
  private listeners: LockListener[] = [];
  private timerId: number = -1;
  private readonly inactivityTimeoutMs: number = 15000;

  onLockRequested(listener: LockListener): void {
    this.listeners.push(listener);
  }

  resetInactivityTimer(): void {
    this.clearInactivityTimer();
    this.timerId = setTimeout((): void => {
      this.notifyLock();
    }, this.inactivityTimeoutMs);
  }

  clearInactivityTimer(): void {
    if (this.timerId !== -1) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
  }

  forceLock(): void {
    this.clearInactivityTimer();
    this.notifyLock();
  }

  // Paired counterpart to forceLock(): releases the guard's pending inactivity
  // timer when the page returns to the foreground. Does NOT reveal data — the
  // view stays LOCKED until a successful authentication flips the auth state.
  unlock(): void {
    this.clearInactivityTimer();
  }

  private notifyLock(): void {
    this.listeners.forEach((listener: LockListener): void => listener());
  }
}

export const sessionGuard = new SessionGuardImpl();
