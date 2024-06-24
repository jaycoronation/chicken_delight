class DropDownModel {
  String id = "";
  String name = "";
  bool isSelected = false;

  DropDownModel({required String idParam, required String nameParam,required bool isSelectedParam}) {
    id = idParam;
    name = nameParam;
    isSelected = isSelectedParam;
  }

  set setId(String value)
  {
    id = value;
  }

  set setName(String value)
  {
    name = value;
  }

  set selected(bool isSelect)
  {
    isSelected = isSelect;
  }
}