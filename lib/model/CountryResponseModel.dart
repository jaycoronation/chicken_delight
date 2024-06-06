import 'dart:convert';
/// countries : [{"id":"1","name":"Afghanistan","phonecode":"93"},{"id":"2","name":"Aland Islands","phonecode":"+358-18"},{"id":"3","name":"Albania","phonecode":"355"},{"id":"4","name":"Algeria","phonecode":"213"},{"id":"5","name":"American Samoa","phonecode":"+1-684"},{"id":"6","name":"Andorra","phonecode":"376"},{"id":"7","name":"Angola","phonecode":"244"},{"id":"8","name":"Anguilla","phonecode":"+1-264"},{"id":"9","name":"Antarctica","phonecode":"672"},{"id":"10","name":"Antigua and Barbuda","phonecode":"+1-268"},{"id":"11","name":"Argentina","phonecode":"54"},{"id":"12","name":"Armenia","phonecode":"374"},{"id":"13","name":"Aruba","phonecode":"297"},{"id":"14","name":"Australia","phonecode":"61"},{"id":"15","name":"Austria","phonecode":"43"},{"id":"16","name":"Azerbaijan","phonecode":"994"},{"id":"17","name":"The Bahamas","phonecode":"+1-242"},{"id":"18","name":"Bahrain","phonecode":"973"},{"id":"19","name":"Bangladesh","phonecode":"880"},{"id":"20","name":"Barbados","phonecode":"+1-246"},{"id":"21","name":"Belarus","phonecode":"375"},{"id":"22","name":"Belgium","phonecode":"32"},{"id":"23","name":"Belize","phonecode":"501"},{"id":"24","name":"Benin","phonecode":"229"},{"id":"25","name":"Bermuda","phonecode":"+1-441"},{"id":"26","name":"Bhutan","phonecode":"975"},{"id":"27","name":"Bolivia","phonecode":"591"},{"id":"28","name":"Bosnia and Herzegovina","phonecode":"387"},{"id":"29","name":"Botswana","phonecode":"267"},{"id":"30","name":"Bouvet Island","phonecode":"0055"},{"id":"31","name":"Brazil","phonecode":"55"},{"id":"32","name":"British Indian Ocean Territory","phonecode":"246"},{"id":"33","name":"Brunei","phonecode":"673"},{"id":"34","name":"Bulgaria","phonecode":"359"},{"id":"35","name":"Burkina Faso","phonecode":"226"},{"id":"36","name":"Burundi","phonecode":"257"},{"id":"37","name":"Cambodia","phonecode":"855"},{"id":"38","name":"Cameroon","phonecode":"237"},{"id":"39","name":"Canada","phonecode":"1"},{"id":"40","name":"Cape Verde","phonecode":"238"},{"id":"41","name":"Cayman Islands","phonecode":"+1-345"},{"id":"42","name":"Central African Republic","phonecode":"236"},{"id":"43","name":"Chad","phonecode":"235"},{"id":"44","name":"Chile","phonecode":"56"},{"id":"45","name":"China","phonecode":"86"},{"id":"46","name":"Christmas Island","phonecode":"61"},{"id":"47","name":"Cocos (Keeling) Islands","phonecode":"61"},{"id":"48","name":"Colombia","phonecode":"57"},{"id":"49","name":"Comoros","phonecode":"269"},{"id":"50","name":"Congo","phonecode":"242"},{"id":"51","name":"Democratic Republic of the Congo","phonecode":"243"},{"id":"52","name":"Cook Islands","phonecode":"682"},{"id":"53","name":"Costa Rica","phonecode":"506"},{"id":"54","name":"Cote D'Ivoire (Ivory Coast)","phonecode":"225"},{"id":"55","name":"Croatia","phonecode":"385"},{"id":"56","name":"Cuba","phonecode":"53"},{"id":"57","name":"Cyprus","phonecode":"357"},{"id":"58","name":"Czech Republic","phonecode":"420"},{"id":"59","name":"Denmark","phonecode":"45"},{"id":"60","name":"Djibouti","phonecode":"253"},{"id":"61","name":"Dominica","phonecode":"+1-767"},{"id":"62","name":"Dominican Republic","phonecode":"+1-809 and 1-829"},{"id":"63","name":"Timor-Leste","phonecode":"670"},{"id":"64","name":"Ecuador","phonecode":"593"},{"id":"65","name":"Egypt","phonecode":"20"},{"id":"66","name":"El Salvador","phonecode":"503"},{"id":"67","name":"Equatorial Guinea","phonecode":"240"},{"id":"68","name":"Eritrea","phonecode":"291"},{"id":"69","name":"Estonia","phonecode":"372"},{"id":"70","name":"Ethiopia","phonecode":"251"},{"id":"71","name":"Falkland Islands","phonecode":"500"},{"id":"72","name":"Faroe Islands","phonecode":"298"},{"id":"73","name":"Fiji Islands","phonecode":"679"},{"id":"74","name":"Finland","phonecode":"358"},{"id":"75","name":"France","phonecode":"33"},{"id":"76","name":"French Guiana","phonecode":"594"},{"id":"77","name":"French Polynesia","phonecode":"689"},{"id":"78","name":"French Southern Territories","phonecode":"262"},{"id":"79","name":"Gabon","phonecode":"241"},{"id":"80","name":"Gambia The","phonecode":"220"},{"id":"81","name":"Georgia","phonecode":"995"},{"id":"82","name":"Germany","phonecode":"49"},{"id":"83","name":"Ghana","phonecode":"233"},{"id":"84","name":"Gibraltar","phonecode":"350"},{"id":"85","name":"Greece","phonecode":"30"},{"id":"86","name":"Greenland","phonecode":"299"},{"id":"87","name":"Grenada","phonecode":"+1-473"},{"id":"88","name":"Guadeloupe","phonecode":"590"},{"id":"89","name":"Guam","phonecode":"+1-671"},{"id":"90","name":"Guatemala","phonecode":"502"},{"id":"91","name":"Guernsey and Alderney","phonecode":"+44-1481"},{"id":"92","name":"Guinea","phonecode":"224"},{"id":"93","name":"Guinea-Bissau","phonecode":"245"},{"id":"94","name":"Guyana","phonecode":"592"},{"id":"95","name":"Haiti","phonecode":"509"},{"id":"96","name":"Heard Island and McDonald Islands","phonecode":"672"},{"id":"97","name":"Honduras","phonecode":"504"},{"id":"98","name":"Hong Kong S.A.R.","phonecode":"852"},{"id":"99","name":"Hungary","phonecode":"36"},{"id":"100","name":"Iceland","phonecode":"354"},{"id":"101","name":"India","phonecode":"91"},{"id":"102","name":"Indonesia","phonecode":"62"},{"id":"103","name":"Iran","phonecode":"98"},{"id":"104","name":"Iraq","phonecode":"964"},{"id":"105","name":"Ireland","phonecode":"353"},{"id":"106","name":"Israel","phonecode":"972"},{"id":"107","name":"Italy","phonecode":"39"},{"id":"108","name":"Jamaica","phonecode":"+1-876"},{"id":"109","name":"Japan","phonecode":"81"},{"id":"110","name":"Jersey","phonecode":"+44-1534"},{"id":"111","name":"Jordan","phonecode":"962"},{"id":"112","name":"Kazakhstan","phonecode":"7"},{"id":"113","name":"Kenya","phonecode":"254"},{"id":"114","name":"Kiribati","phonecode":"686"},{"id":"115","name":"North Korea","phonecode":"850"},{"id":"116","name":"South Korea","phonecode":"82"},{"id":"117","name":"Kuwait","phonecode":"965"},{"id":"118","name":"Kyrgyzstan","phonecode":"996"},{"id":"119","name":"Laos","phonecode":"856"},{"id":"120","name":"Latvia","phonecode":"371"},{"id":"121","name":"Lebanon","phonecode":"961"},{"id":"122","name":"Lesotho","phonecode":"266"},{"id":"123","name":"Liberia","phonecode":"231"},{"id":"124","name":"Libya","phonecode":"218"},{"id":"125","name":"Liechtenstein","phonecode":"423"},{"id":"126","name":"Lithuania","phonecode":"370"},{"id":"127","name":"Luxembourg","phonecode":"352"},{"id":"128","name":"Macau S.A.R.","phonecode":"853"},{"id":"129","name":"North Macedonia","phonecode":"389"},{"id":"130","name":"Madagascar","phonecode":"261"},{"id":"131","name":"Malawi","phonecode":"265"},{"id":"132","name":"Malaysia","phonecode":"60"},{"id":"133","name":"Maldives","phonecode":"960"},{"id":"134","name":"Mali","phonecode":"223"},{"id":"135","name":"Malta","phonecode":"356"},{"id":"136","name":"Man (Isle of)","phonecode":"+44-1624"},{"id":"137","name":"Marshall Islands","phonecode":"692"},{"id":"138","name":"Martinique","phonecode":"596"},{"id":"139","name":"Mauritania","phonecode":"222"},{"id":"140","name":"Mauritius","phonecode":"230"},{"id":"141","name":"Mayotte","phonecode":"262"},{"id":"142","name":"Mexico","phonecode":"52"},{"id":"143","name":"Micronesia","phonecode":"691"},{"id":"144","name":"Moldova","phonecode":"373"},{"id":"145","name":"Monaco","phonecode":"377"},{"id":"146","name":"Mongolia","phonecode":"976"},{"id":"147","name":"Montenegro","phonecode":"382"},{"id":"148","name":"Montserrat","phonecode":"+1-664"},{"id":"149","name":"Morocco","phonecode":"212"},{"id":"150","name":"Mozambique","phonecode":"258"},{"id":"151","name":"Myanmar","phonecode":"95"},{"id":"152","name":"Namibia","phonecode":"264"},{"id":"153","name":"Nauru","phonecode":"674"},{"id":"154","name":"Nepal","phonecode":"977"},{"id":"155","name":"Bonaire, Sint Eustatius and Saba","phonecode":"599"},{"id":"156","name":"Netherlands","phonecode":"31"},{"id":"157","name":"New Caledonia","phonecode":"687"},{"id":"158","name":"New Zealand","phonecode":"64"},{"id":"159","name":"Nicaragua","phonecode":"505"},{"id":"160","name":"Niger","phonecode":"227"},{"id":"161","name":"Nigeria","phonecode":"234"},{"id":"162","name":"Niue","phonecode":"683"},{"id":"163","name":"Norfolk Island","phonecode":"672"},{"id":"164","name":"Northern Mariana Islands","phonecode":"+1-670"},{"id":"165","name":"Norway","phonecode":"47"},{"id":"166","name":"Oman","phonecode":"968"},{"id":"167","name":"Pakistan","phonecode":"92"},{"id":"168","name":"Palau","phonecode":"680"},{"id":"169","name":"Palestinian Territory Occupied","phonecode":"970"},{"id":"170","name":"Panama","phonecode":"507"},{"id":"171","name":"Papua New Guinea","phonecode":"675"},{"id":"172","name":"Paraguay","phonecode":"595"},{"id":"173","name":"Peru","phonecode":"51"},{"id":"174","name":"Philippines","phonecode":"63"},{"id":"175","name":"Pitcairn Island","phonecode":"870"},{"id":"176","name":"Poland","phonecode":"48"},{"id":"177","name":"Portugal","phonecode":"351"},{"id":"178","name":"Puerto Rico","phonecode":"+1-787 and 1-939"},{"id":"179","name":"Qatar","phonecode":"974"},{"id":"180","name":"Reunion","phonecode":"262"},{"id":"181","name":"Romania","phonecode":"40"},{"id":"182","name":"Russia","phonecode":"7"},{"id":"183","name":"Rwanda","phonecode":"250"},{"id":"184","name":"Saint Helena","phonecode":"290"},{"id":"185","name":"Saint Kitts and Nevis","phonecode":"+1-869"},{"id":"186","name":"Saint Lucia","phonecode":"+1-758"},{"id":"187","name":"Saint Pierre and Miquelon","phonecode":"508"},{"id":"188","name":"Saint Vincent and the Grenadines","phonecode":"+1-784"},{"id":"189","name":"Saint-Barthelemy","phonecode":"590"},{"id":"190","name":"Saint-Martin (French part)","phonecode":"590"},{"id":"191","name":"Samoa","phonecode":"685"},{"id":"192","name":"San Marino","phonecode":"378"},{"id":"193","name":"Sao Tome and Principe","phonecode":"239"},{"id":"194","name":"Saudi Arabia","phonecode":"966"},{"id":"195","name":"Senegal","phonecode":"221"},{"id":"196","name":"Serbia","phonecode":"381"},{"id":"197","name":"Seychelles","phonecode":"248"},{"id":"198","name":"Sierra Leone","phonecode":"232"},{"id":"199","name":"Singapore","phonecode":"65"},{"id":"200","name":"Slovakia","phonecode":"421"},{"id":"201","name":"Slovenia","phonecode":"386"},{"id":"202","name":"Solomon Islands","phonecode":"677"},{"id":"203","name":"Somalia","phonecode":"252"},{"id":"204","name":"South Africa","phonecode":"27"},{"id":"205","name":"South Georgia","phonecode":"500"},{"id":"206","name":"South Sudan","phonecode":"211"},{"id":"207","name":"Spain","phonecode":"34"},{"id":"208","name":"Sri Lanka","phonecode":"94"},{"id":"209","name":"Sudan","phonecode":"249"},{"id":"210","name":"Suriname","phonecode":"597"},{"id":"211","name":"Svalbard and Jan Mayen Islands","phonecode":"47"},{"id":"212","name":"Eswatini","phonecode":"268"},{"id":"213","name":"Sweden","phonecode":"46"},{"id":"214","name":"Switzerland","phonecode":"41"},{"id":"215","name":"Syria","phonecode":"963"},{"id":"216","name":"Taiwan","phonecode":"886"},{"id":"217","name":"Tajikistan","phonecode":"992"},{"id":"218","name":"Tanzania","phonecode":"255"},{"id":"219","name":"Thailand","phonecode":"66"},{"id":"220","name":"Togo","phonecode":"228"},{"id":"221","name":"Tokelau","phonecode":"690"},{"id":"222","name":"Tonga","phonecode":"676"},{"id":"223","name":"Trinidad and Tobago","phonecode":"+1-868"},{"id":"224","name":"Tunisia","phonecode":"216"},{"id":"225","name":"Turkey","phonecode":"90"},{"id":"226","name":"Turkmenistan","phonecode":"993"},{"id":"227","name":"Turks and Caicos Islands","phonecode":"+1-649"},{"id":"228","name":"Tuvalu","phonecode":"688"},{"id":"229","name":"Uganda","phonecode":"256"},{"id":"230","name":"Ukraine","phonecode":"380"},{"id":"231","name":"United Arab Emirates","phonecode":"971"},{"id":"232","name":"United Kingdom","phonecode":"44"},{"id":"233","name":"United States","phonecode":"1"},{"id":"234","name":"United States Minor Outlying Islands","phonecode":"1"},{"id":"235","name":"Uruguay","phonecode":"598"},{"id":"236","name":"Uzbekistan","phonecode":"998"},{"id":"237","name":"Vanuatu","phonecode":"678"},{"id":"238","name":"Vatican City State (Holy See)","phonecode":"379"},{"id":"239","name":"Venezuela","phonecode":"58"},{"id":"240","name":"Vietnam","phonecode":"84"},{"id":"241","name":"Virgin Islands (British)","phonecode":"+1-284"},{"id":"242","name":"Virgin Islands (US)","phonecode":"+1-340"},{"id":"243","name":"Wallis and Futuna Islands","phonecode":"681"},{"id":"244","name":"Western Sahara","phonecode":"212"},{"id":"245","name":"Yemen","phonecode":"967"},{"id":"246","name":"Zambia","phonecode":"260"},{"id":"247","name":"Zimbabwe","phonecode":"263"},{"id":"248","name":"Kosovo","phonecode":"383"},{"id":"249","name":"Curaçao","phonecode":"599"},{"id":"250","name":"Sint Maarten (Dutch part)","phonecode":"1721"}]
/// success : 1
/// message : ""

CountryResponseModel countryResponseModelFromJson(String str) => CountryResponseModel.fromJson(json.decode(str));
String countryResponseModelToJson(CountryResponseModel data) => json.encode(data.toJson());
class CountryResponseModel {
  CountryResponseModel({
      List<Countries>? countries, 
      num? success, 
      String? message,}){
    _countries = countries;
    _success = success;
    _message = message;
}

  CountryResponseModel.fromJson(dynamic json) {
    if (json['countries'] != null) {
      _countries = [];
      json['countries'].forEach((v) {
        _countries?.add(Countries.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
  }
  List<Countries>? _countries;
  num? _success;
  String? _message;
CountryResponseModel copyWith({  List<Countries>? countries,
  num? success,
  String? message,
}) => CountryResponseModel(  countries: countries ?? _countries,
  success: success ?? _success,
  message: message ?? _message,
);
  List<Countries>? get countries => _countries;
  num? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_countries != null) {
      map['countries'] = _countries?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

/// id : "1"
/// name : "Afghanistan"
/// phonecode : "93"

Countries countriesFromJson(String str) => Countries.fromJson(json.decode(str));
String countriesToJson(Countries data) => json.encode(data.toJson());
class Countries {
  Countries({
      String? id, 
      String? name, 
      String? phonecode,}){
    _id = id;
    _name = name;
    _phonecode = phonecode;
}

  Countries.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _phonecode = json['phonecode'];
  }
  String? _id;
  String? _name;
  String? _phonecode;
Countries copyWith({  String? id,
  String? name,
  String? phonecode,
}) => Countries(  id: id ?? _id,
  name: name ?? _name,
  phonecode: phonecode ?? _phonecode,
);
  String? get id => _id;
  String? get name => _name;
  String? get phonecode => _phonecode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['phonecode'] = _phonecode;
    return map;
  }

}