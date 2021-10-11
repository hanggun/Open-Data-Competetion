/// a_tax_rank :A
/// administrative_sanction_count : 0
/// credit_risk_score : 0
/// evaluate : ["极低","极低","极低","极低","极低"]
/// neg_count : 4
/// neu_count : 15
/// operating_risk_score : 0
/// owing_tax_count : 0
/// pos_count : 1
/// public_opinion_risk_score : 0.6008869179600886
/// suggestion : "建议业务往来"
/// sum_score : 0.12017738359201774
/// tax_audit : 0

class DemoRiskBean {
  String aTaxRank;
  num administrativeSanctionCount;
  num creditRiskScore;
  List<String> evaluate;
  num negCount;
  num neuCount;
  num operatingRiskScore;
  num owingTaxCount;
  num posCount;
  num publicOpinionRiskScore;
  String suggestion;
  num sumScore;
  num taxAudit;

  DemoRiskBean(
      {this.aTaxRank,
      this.administrativeSanctionCount,
      this.creditRiskScore,
      this.evaluate,
      this.negCount,
      this.neuCount,
      this.operatingRiskScore,
      this.owingTaxCount,
      this.posCount,
      this.publicOpinionRiskScore,
      this.suggestion,
      this.sumScore,
      this.taxAudit});

  DemoRiskBean.fromJson(dynamic json) {
    aTaxRank = json['a_tax_rank'];
    administrativeSanctionCount = json['administrative_sanction_count'];
    creditRiskScore = json['credit_risk_score'];
    evaluate = json['evaluate'] != null ? json['evaluate'].cast<String>() : [];
    negCount = json['neg_count'];
    neuCount = json['neu_count'];
    operatingRiskScore = json['operating_risk_score'];
    owingTaxCount = json['owing_tax_count'];
    posCount = json['pos_count'];
    publicOpinionRiskScore = json['public_opinion_risk_score'];
    suggestion = json['suggestion'];
    sumScore = json['sum_score'] ?? 0;
    taxAudit = json['tax_audit'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['a_tax_rank'] = aTaxRank;
    map['administrative_sanction_count'] = administrativeSanctionCount;
    map['credit_risk_score'] = creditRiskScore;
    map['evaluate'] = evaluate;
    map['neg_count'] = negCount;
    map['neu_count'] = neuCount;
    map['operating_risk_score'] = operatingRiskScore;
    map['owing_tax_count'] = owingTaxCount;
    map['pos_count'] = posCount;
    map['public_opinion_risk_score'] = publicOpinionRiskScore;
    map['suggestion'] = suggestion;
    map['sum_score'] = sumScore;
    map['tax_audit'] = taxAudit;
    return map;
  }
}
