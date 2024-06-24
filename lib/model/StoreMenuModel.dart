
class StoreMenuGetSet {
  String name ="";
  String count = "";
  String bgColor = "";
  String arrowColor = "";
  String itemIcon = "";
  String labelColor = "";

  StoreMenuGetSet({required String nameStatic, required String bgColorStatic, required String itemIconStatic,required String countStatic,required String arrowColorStatic, required String labelColorStatic}) {
    name = nameStatic;
    bgColor = bgColorStatic;
    itemIcon = itemIconStatic;
    count = countStatic;
    arrowColor = arrowColorStatic;
    labelColor = labelColorStatic;
  }
}

class CategoryMenu {
  String id = "";
  String name = "";
  bool isSelected = false;


  CategoryMenu({required String idStatic, required String nameStatic, required bool isSelectedStatic}) {
    id = idStatic;
    name = nameStatic;
    isSelected = isSelectedStatic;
  }

  set setId(String value)
  {
    id = value;
  }

  set setName(String value)
  {
    name = value;
  }

  set setIsSelected(bool value)
  {
    isSelected = value;
  }

}
