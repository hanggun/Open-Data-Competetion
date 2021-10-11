/// approval_date : "Mon, 22 Jul 2019 00:00:00 GMT"
/// business_period : "2003-01-29至9999-09-09"
/// business_registration_number : "330682000074220"
/// business_scope : "电机制造、修理；电机及零配件销售；进出口业务贸易（国家法律法规禁止项目除外，限制项目取得许可方可经营）"
/// business_state : "存续"
/// city : "绍兴市"
/// company_id : "913306047470096609"
/// company_name : "绍兴上虞五州电机制造有限公司"
/// company_type : "有限责任公司(自然人投资或控股)"
/// email : ""
/// establish_date : "Wed, 29 Jan 2003 00:00:00 GMT"
/// industry_category : "通用设备制造业"
/// legal_representative : "胡建标"
/// organization_code : "747009660"
/// province : "浙江省"
/// registered_address : "绍兴市上虞区百官城东工业园区"
/// registration_authority : "绍兴市上虞区市场监督管理局"
/// taxpayer_identification_number : "913306047470096609"
/// telephone : ""
/// unified_social_credit_code : "913306047470096609"

class DemoCompanyBean {
  String approvalDate;
  String businessPeriod;
  String businessRegistrationNumber;
  String businessScope;
  String businessState;
  String city;
  String id;
  String companyName;
  String companyType;
  String email;
  String establishDate;
  String industryCategory;
  String legalRepresentative;
  String organizationCode;
  String province;
  String registeredAddress;
  String registrationAuthority;
  String taxpayerIdentificationNumber;
  String telephone;
  String unifiedSocialCreditCode;

  DemoCompanyBean(
      {this.approvalDate,
      this.businessPeriod,
      this.businessRegistrationNumber,
      this.businessScope,
      this.businessState,
      this.city,
      this.id,
      this.companyName,
      this.companyType,
      this.email,
      this.establishDate,
      this.industryCategory,
      this.legalRepresentative,
      this.organizationCode,
      this.province,
      this.registeredAddress,
      this.registrationAuthority,
      this.taxpayerIdentificationNumber,
      this.telephone,
      this.unifiedSocialCreditCode});

  DemoCompanyBean.fromJson(dynamic json) {
    approvalDate = json['approval_date'];
    businessPeriod = json['business_period'];
    businessRegistrationNumber = json['business_registration_number'];
    businessScope = json['business_scope'];
    businessState = json['business_state'];
    city = json['city'];
    id = json['company_id'];
    companyName = json['company_name'];
    companyType = json['company_type'];
    email = json['email'];
    establishDate = json['establish_date'];
    industryCategory = json['industry_category'];
    legalRepresentative = json['legal_representative'];
    organizationCode = json['organization_code'];
    province = json['province'];
    registeredAddress = json['registered_address'];
    registrationAuthority = json['registration_authority'];
    taxpayerIdentificationNumber = json['taxpayer_identification_number'];
    telephone = json['telephone'];
    unifiedSocialCreditCode = json['unified_social_credit_code'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['approval_date'] = approvalDate;
    map['business_period'] = businessPeriod;
    map['business_registration_number'] = businessRegistrationNumber;
    map['business_scope'] = businessScope;
    map['business_state'] = businessState;
    map['city'] = city;
    map['company_id'] = id;
    map['company_name'] = companyName;
    map['company_type'] = companyType;
    map['email'] = email;
    map['establish_date'] = establishDate;
    map['industry_category'] = industryCategory;
    map['legal_representative'] = legalRepresentative;
    map['organization_code'] = organizationCode;
    map['province'] = province;
    map['registered_address'] = registeredAddress;
    map['registration_authority'] = registrationAuthority;
    map['taxpayer_identification_number'] = taxpayerIdentificationNumber;
    map['telephone'] = telephone;
    map['unified_social_credit_code'] = unifiedSocialCreditCode;
    return map;
  }
}
