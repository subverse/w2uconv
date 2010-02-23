module Lists


  # successors of prefix 'ga' (without 'g.ya')
  # ga_succs(arg::string)::string
  def ga_succs(arg)
    arr = ["gc", "gny", "gt", "gd", "gn", "gts", "gzh","gz", "gsh", "gs"]
    #h = Hash.[]("gc"=>"gc", "gny"=>"gny", "gt"=>"gt", "gd"=>"gd", "gn"=>"gn", "gts"=>"gts", "gzh"=>"gzh",
               #"gz"=>"gz", "gsh"=>"gsh", "gs"=>"gs")
    h = to_hash(arr)
    h[arg]
  end # ga_succs



  # unicode-hash [wylie=>unicode]
  # tuc(arg:string)::unicode
  def tuc(arg)
    h = Hash.[]("."=>"&#x0F0B;", "|"=>"&#x0F0D;", ";"=>"&#x0F14;", ""=>"",
      "ka"=>"&#x0F40;", "kha"=>"&#x0F41;", "ga"=>"&#x0F42;", "nga"=>"&#x0F44;",
      "ca"=>"&#x0F45;", "cha"=>"&#x0F46;", "ja"=>"&#x0F47;", "nya"=>"&#x0F49;",
      "ta"=>"&#x0F4F;", "tha"=>"&#x0F50;", "da"=>"&#x0F51;", "na"=>"&#x0F53;",
      "pa"=>"&#x0F54;", "pha"=>"&#x0F55;", "ba"=>"&#x0F56;", "ma"=>"&#x0F58;",
      "tsa"=>"&#x0F59;", "tsha"=>"&#x0F5A;", "dza"=>"&#x0F5B;", "wa"=>"&#x0F5D;",
      "zha"=>"&#x0F5E;", "za"=>"&#x0F5F;", "'a"=>"&#x0F60;", "ya"=>"&#x0F61;",
      "ra"=>"&#x0F62;", "la"=>"&#x0F63;", "sha"=>"&#x0F64;", "sa"=>"&#x0F66;",
      "ha"=>"&#x0F67;", "a"=>"&#x0F68;",
      # numbers !!! better include number_generator
      "0"=>"&#x0F20;", "1"=>"&#x0F21;", "2"=>"&#x0F22;", "3"=>"&#x0F23;",
      "4"=>"&#x0F24;", "5"=>"&#x0F25;", "6"=>"&#x0F26;", "7"=>"&#x0F27;",
      "8"=>"&#x0F28;", "9"=>"&#x0F29;",
      # vowel signs
      ".e"=>"&#x0F7A;", ".i"=>"&#x0F72;", ".o"=>"&#x0F7C;", ".u"=>"&#x0F74;",
      # double vowel signs
      "E" => "&#x0F7B;", "O" => "&#x0F7D;",
      # subscribed characters
      "x_ka"=>"&#x0F90;", "x_kha"=>"&#x0F91;", "x_ga"=>"&#x0F92;", "x_nga"=>"&#x0F94;",
      "x_ca"=>"&#x0F95;", "x_cha"=>"&#x0F96;", "x_ja"=>"&#x0F97;", "x_nya"=>"&#x0F99;",
      "x_ta"=>"&#x0F9F;", "x_tha"=>"&#x0F90;", "x_da"=>"&#x0FA1;", "x_na"=>"&#x0FA3;",
      "x_pa"=>"&#x0FA4;", "x_pha"=>"&#x0FA5;", "x_ba"=>"&#x0FA6;", "x_ma"=>"&#x0FA8;",
      "x_tsa"=>"&#x0FA9;", "x_tsha"=>"&#x0FAA;", "x_dza"=>"&#x0FAB;", "x_wa"=>"&#x0FAD;",
      "x_zha"=>"&#x0FAE;", "x_za"=>"&#x0FAF;", "x_'a"=>"&#x0F71;", "x_ya"=>"&#x0FB1;",
      "x_ra"=>"&#x0FB2;", "x_la"=>"&#x0FB3;", "x_sha"=>"&#x0FB4;", "x_sa"=>"&#x0FB6;",
      "x_ha"=>"&#x0FB7;", "x_a"=>"&#x0FB8;",
      # superscribed character
      "ra_x"=>"&#x0F62;",
      # revered letters
      "Ta"=>"&#x0F4A;", "Tha" => "&#x0F4B;", "Da" => "&#x0F4C;", "Na" => "&#x0F4E;",
      "Sha" => "&#x0F65;")

    result = h[arg]
    if result != nil
      erg = result
    else
      erg = ""
    end
    return erg
  end #end tuc



  # single letter (with /aeiou/)
  # letters(arg::string)::unicode
  def letters(arg)
    return tuc(arg.sub(/[eiou]/, 'a')) != ""
  end #end letters



  # characters with super- and subscript
  # stacks(arg::string)::string
  def stacks(arg)
    ya_ta = tuc("x_ya")
    ra_ta = tuc("x_ra")
    la_ta = tuc("x_la")
    wa_ta = tuc("x_wa")

    ra_go = tuc("ra_x")
    la_go = tuc("la")
    sa_go = tuc("sa")

    h = Hash.[](
    # subscript YA
    "ky"=>tuc("ka")+ya_ta, "khy"=>tuc("kha")+ya_ta, "gy"=>tuc("ga")+ya_ta,
    "py"=>tuc("pa")+ya_ta, "phy"=>tuc("pha")+ya_ta, "by"=>tuc("ba")+ya_ta, "my"=>tuc("ma")+ya_ta,
    # subscript RA
    "kr"=>tuc("ka")+ra_ta,  "khr"=>tuc("kha")+ra_ta, "gr"=>tuc("ga")+ra_ta,
    "tr"=>tuc("ta")+ra_ta, "thr"=>tuc("tha")+ra_ta, "dr"=>tuc("da")+ra_ta,
    "pr"=>tuc("pa")+ra_ta, "phr"=>tuc("pha")+ra_ta, "br"=>tuc("ba")+ra_ta, "mr"=>tuc("ma")+ra_ta,
    "shr"=>tuc("sha")+ra_ta, "sr"=>tuc("sa")+ra_ta, "hr"=>tuc("ha")+ra_ta,
    # subscript LA
    "kl"=>tuc("ka")+la_ta,  "gl"=>tuc("ga")+la_ta, "bl"=>tuc("ba")+la_ta,
    "zl"=>tuc("za")+la_ta,  "rl"=>tuc("ra")+la_ta, "sl"=>tuc("sa")+la_ta,
    # subscript WA
    "kw"=>tuc("ka")+wa_ta,  "khw"=>tuc("kha")+wa_ta, "gw"=>tuc("ga")+wa_ta, "grw"=>tuc("ga")+ra_ta+wa_ta,
    "cw"=>tuc("ca")+wa_ta, "nyw"=>tuc("nya")+wa_ta, "tw"=>tuc("ta")+wa_ta,
    "dw"=>tuc("da")+wa_ta, "tsw"=>tuc("tsa")+wa_ta, "tshw"=>tuc("tsha")+wa_ta,
    "zhw"=>tuc("zha")+wa_ta, "zw"=>tuc("za")+wa_ta, "rw"=>tuc("ra")+wa_ta,
    "lw"=>tuc("la")+wa_ta, "shw"=>tuc("sha")+wa_ta, "sw"=>tuc("sa")+wa_ta, "hw"=>tuc("ha")+wa_ta,
    # subscript 'A
    "t'"=>tuc("ta")+tuc("x_'a"),
    # superscript RA
    "rk"=>ra_go+tuc("x_ka"), "rg"=>ra_go+tuc("x_ga"), "rng"=>ra_go+tuc("x_nga"), "rj"=>ra_go+tuc("x_ja"),
    "rny"=>ra_go+tuc("x_nya"), "rt"=>ra_go+tuc("x_ta"), "rd"=>ra_go+tuc("x_da"), "rn"=>ra_go+tuc("x_na"), "rm"=>ra_go+tuc("x_ma"),
    "rb"=>ra_go+tuc("x_ba"), "rts"=>ra_go+tuc("x_tsa"), "rdz"=>ra_go+tuc("x_dza"),
    # superscript LA
    "lk"=>la_go+tuc("x_ka"), "lg"=>la_go+tuc("x_ga"), "lng"=>la_go+tuc("x_nga"), "lc"=>la_go+tuc("x_ca"),
    "lj"=>la_go+tuc("x_ja"), "lt"=>la_go+tuc("x_ta"), "ld"=>la_go+tuc("x_da"), "lp"=>la_go+tuc("x_pa"),
    "lb"=>la_go+tuc("x_ba"), "lh"=>la_go+tuc("x_ha"),
    # superscript SA
    "sk"=>sa_go+tuc("x_ka"), "sg"=>sa_go+tuc("x_ga"), "sng"=>sa_go+tuc("x_nga"), "sny"=>sa_go+tuc("x_nya"),
    "st"=>sa_go+tuc("x_ta"), "sd"=>sa_go+tuc("x_da"), "sn"=>sa_go+tuc("x_na"), "sp"=>sa_go+tuc("x_pa"),
    "sb"=>sa_go+tuc("x_ba"), "sm"=>sa_go+tuc("x_ma"), "sts"=>sa_go+tuc("x_tsa"))
    h[arg]
  end #end stacks



  # list of possible characters with subscript if super- and subscript exists
  # stack_sub(arg::string)::string
  def stacks_sub(arg)
    ya_ta = tuc("x_ya")
    ra_ta = tuc("x_ra")
    la_ta = tuc("x_la")
    wa_ta = tuc("x_wa")

    h = Hash.[](
    # subscript ya
    "ky"=>ya_ta, "khy"=>ya_ta, "gy"=>ya_ta,
    "py"=>ya_ta, "phy"=>ya_ta, "by"=>ya_ta, "my"=>ya_ta,
    # subscript ra
    "kr"=>ra_ta, "khr"=>ra_ta, "gr"=>ra_ta,
    "tr"=>ra_ta, "thr"=>ra_ta, "dr"=>ra_ta,
    "pr"=>ra_ta, "phr"=>ra_ta, "br"=>ra_ta, "mr"=>ra_ta,
    "shr"=>ra_ta, "sr"=>ra_ta, "hr"=>ra_ta,
    # subscript la
    "kl"=>la_ta, "gl"=>la_ta, "bl"=>la_ta,
    "zl"=>la_ta, "rl"=>la_ta, "sl"=>la_ta,
    # subscript wa
    "kw"=>wa_ta, "khw"=>wa_ta, "gw"=>wa_ta, "grw"=>ra_ta+wa_ta,
    "cw"=>wa_ta, "nyw"=>wa_ta, "tw"=>wa_ta,
    "dw"=>wa_ta, "tsw"=>wa_ta, "tshw"=>wa_ta,
    "zhw"=>wa_ta, "zw"=>wa_ta, "rw"=>wa_ta,
    "lw"=>wa_ta, "shw"=>wa_ta, "sw"=>wa_ta, "hw"=>wa_ta,
    # subscript 'a
    "t'"=>tuc("x_'a"), "h'"=>tuc("x_'a"), "a'"=>tuc("x_'a"))
    h[arg]
  end #end stacks_sub



  # List of superscripts
  # sup_stack_list(arg::string)::array
  def sup_stack_list
    a = Array.[]("rk", "rg", "rng", "rj", "rny", "rt", "rd", "rn", "rb", "rts", "rdz", "rm",
         "lk", "lg", "lng", "lc", "lj", "lt", "ld", "lp", "lb", "lh",
         "sk", "sg", "sng", "sny", "st", "sd", "sn", "sp", "sb", "sm", "sts")
    return a
  end #end sup_stack_list



  # List of subscripts
  # sub_stack_list(arg::string)::string
  def sub_stack_list
    a = Array.[]("ky", "khy", "gy", "py", "phy", "by", "my",
           "kr", "khr", "gr", "tr", "thr", "dr", "pr", "phr", "br", "mr", "shr", "sr", "hr",
           "kl", "gl", "bl",  "zl", "rl", "sl",
           "kw", "khw", "gw", "cw", "nyw", "tw", "dw", "tsw", "tshw", "zhw", "zw", "rw", "lw", "shw", "sw", "hw",
           "t'", "h'", "a'",
           "grw")
    return a
  end #end sub_stack_list



  private



  # to_hash(arr::array)::hash
  def to_hash(arr)
    h = Hash.[]
    arr.each do |elem|
      h[elem] = elem
    end
    return h
  end #end to_hash


end #end Lists
