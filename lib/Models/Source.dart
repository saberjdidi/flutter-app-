class Source {
  int? CodeSourceAct;
  late String SourceAct;
  late int act_simp;
  late int obs_constat;
  late int Supp;

  /*sourceMap(){
    var mapping = Map<String, dynamic>();
    mapping['CodeSourceAct'] = CodeSourceAct;
    mapping['SourceAct'] = SourceAct;
    mapping['act_simp'] = act_simp;
    mapping['obs_constat'] = obs_constat;
    mapping['Supp'] = Supp;

    return mapping;
  } */
  // same result of 2 methods
  Map<String, dynamic> sourceMap(){
    var map = <String, dynamic>{
      'CodeSourceAct' : CodeSourceAct,
      'SourceAct' : SourceAct,
      'act_simp' : act_simp,
      'obs_constat' : obs_constat,
      'Supp' : Supp
    };
    return map;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Source? model) {
    return this.CodeSourceAct == model?.CodeSourceAct;
  }

  @override
  String toString() => SourceAct;
}