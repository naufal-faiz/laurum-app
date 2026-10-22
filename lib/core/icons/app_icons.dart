import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

enum AppIcons {
  check(Ionicons.checkmark),
  info(Ionicons.informationCircleOutline),
  back(Ionicons.arrowBackOutline),
  person(Ionicons.personOutline),
  avatar(Ionicons.personCircleOutline),
  search(Ionicons.searchOutline),
  receipt(Ionicons.receiptOutline),
  receiptActive(Ionicons.receipt),
  customers(Ionicons.peopleOutline),
  customersActive(Ionicons.people),
  reports(Ionicons.barChartOutline),
  reportsActive(Ionicons.barChart),
  menu(Ionicons.gridOutline),
  menuActive(Ionicons.grid),
  calendar(Ionicons.calendarOutline),
  wallet(Ionicons.walletOutline),
  phone(Ionicons.callOutline),
  delete(Ionicons.trashOutline),
  location(Ionicons.locationOutline),
  close(Ionicons.close),
  service(Ionicons.shirtOutline),
  queue(Ionicons.fileTrayOutline),
  queueActive(Ionicons.fileTray),
  printer(Ionicons.printOutline),
  alert(Ionicons.alertCircleOutline),
  lock(Ionicons.lockClosedOutline),
  time(Ionicons.timeOutline),
  add(Ionicons.add),
  chat(Ionicons.chatbubbleOutline),
  refresh(Ionicons.refreshOutline),
  privacy(Ionicons.shieldCheckmarkOutline),
  expand(Ionicons.chevronDownOutline),
  next(Ionicons.chevronForwardOutline),
  more(Ionicons.ellipsisVertical),
  visible(Ionicons.eyeOutline),
  mail(Ionicons.mailOutline),
  qrCode(Ionicons.qrCodeOutline),
  offline(Ionicons.cloudOfflineOutline),
  addCustomer(Ionicons.personAddOutline),
  backspace(Ionicons.backspaceOutline);

  const AppIcons(this.data);

  final IconData data;
}
