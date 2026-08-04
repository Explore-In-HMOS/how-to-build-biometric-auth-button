import { BpReading, getMockBloodPressureReadings } from '../../model/HealthData';

@Component
export struct BloodPressureHistoryPanel {
  private readings: BpReading[] = getMockBloodPressureReadings();

  build() {
    Column({ space: 6 }) {
      Text($r('app.string.blood_pressure_section_title'))
        .fontSize(14)
        .fontColor($r('app.color.panel_title_color'))

      ForEach(this.readings, (reading: BpReading) => {
        Row() {
          Text(`${reading.systolic}/${reading.diastolic}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.panel_text_color'))
          Blank()
          Text(reading.timestamp)
            .fontSize(12)
            .fontColor($r('app.color.panel_title_color'))
        }
        .width('100%')
      }, (reading: BpReading) => reading.timestamp)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
