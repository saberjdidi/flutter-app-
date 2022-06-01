class ActionModel {
  int? NAct;
  late String Act;
  late String MatDeclancheur;
  late String DescPb;
  late String Date;
  late String Cause;
  late int CodeSite;
  late int CodeSourceAct;
  late int CodeTypeAct;
  late int id_domaine;
  late String RefAudit;

  actionMap(){
    var mapping = Map<String, dynamic>();
    mapping['NAct'] = NAct;
    mapping['Act'] = Act;
    mapping['MatDeclancheur'] = MatDeclancheur;
    mapping['DescPb'] = DescPb;
    mapping['Date'] = Date;
    mapping['Cause'] = Cause;
    mapping['CodeSite'] = CodeSite;
    mapping['CodeSourceAct'] = CodeSourceAct;
    mapping['CodeTypeAct'] = CodeTypeAct;
    mapping['id_domaine'] = id_domaine;
    mapping['RefAudit'] = RefAudit;

    return mapping;
  }
}