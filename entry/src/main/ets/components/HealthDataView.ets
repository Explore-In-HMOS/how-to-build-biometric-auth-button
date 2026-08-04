import { BloodPressureHistoryPanel } from './panels/BloodPressureHistoryPanel';
import { MedicationSchedulePanel } from './panels/MedicationSchedulePanel';
import { EmergencyContactsPanel } from './panels/EmergencyContactsPanel';
import { sessionGuard } from '../common/SessionGuard';

@Component
export struct HealthDataView {
  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text($r('app.string.health_data_title'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.panel_text_color'))

        BloodPressureHistoryPanel()
        MedicationSchedulePanel()
        EmergencyContactsPanel()
      }
      .width('100%')
      .padding(12)
    }
    .width('100%')
    .height('100%')
    .onTouch((): void => sessionGuard.resetInactivityTimer())
  }
}
