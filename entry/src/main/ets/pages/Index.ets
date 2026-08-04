import { AuthGateView } from '../components/AuthGateView';
import { sessionGuard } from '../common/SessionGuard';

@Entry
@Component
struct Index {
  onPageHide(): void {
    sessionGuard.forceLock();
  }

  onPageShow(): void {
    // Re-arm the guard on foreground; the view stays LOCKED until re-auth.
    sessionGuard.unlock();
  }

  build() {
    Column() {
      AuthGateView()
    }
    .width('100%')
    .height('100%');
  }
}