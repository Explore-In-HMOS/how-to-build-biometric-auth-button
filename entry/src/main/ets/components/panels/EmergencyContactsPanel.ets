import { EmergencyContact, getMockEmergencyContacts } from '../../model/HealthData';

@Component
export struct EmergencyContactsPanel {
  private contacts: EmergencyContact[] = getMockEmergencyContacts();

  build() {
    Column({ space: 6 }) {
      Text($r('app.string.emergency_contacts_section_title'))
        .fontSize(14)
        .fontColor($r('app.color.panel_title_color'))

      ForEach(this.contacts, (contact: EmergencyContact) => {
        Column({ space: 2 }) {
          Text(`${contact.name} · ${contact.relation}`)
            .fontSize(15)
            .fontColor($r('app.color.panel_text_color'))
          Text(contact.phoneNumber)
            .fontSize(12)
            .fontColor($r('app.color.panel_title_color'))
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }, (contact: EmergencyContact) => contact.phoneNumber)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
