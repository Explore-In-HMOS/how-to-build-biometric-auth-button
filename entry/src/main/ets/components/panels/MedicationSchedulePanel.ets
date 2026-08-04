import { Medication, getMockMedications } from '../../model/HealthData';

@Component
export struct MedicationSchedulePanel {
  private medications: Medication[] = getMockMedications();

  build() {
    Column({ space: 6 }) {
      Text($r('app.string.medication_section_title'))
        .fontSize(14)
        .fontColor($r('app.color.panel_title_color'))

      ForEach(this.medications, (medication: Medication) => {
        Row() {
          Text(medication.name)
            .fontSize(15)
            .fontColor($r('app.color.panel_text_color'))
          Blank()
          Text(`${medication.dosage} · ${medication.scheduleTime}`)
            .fontSize(12)
            .fontColor($r('app.color.panel_title_color'))
        }
        .width('100%')
      }, (medication: Medication) => medication.name)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
