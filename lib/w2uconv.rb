require 'lists'
include Lists

module W2uconv


  # Converts row of Wylie into corresponding unicode characters
  # convert(arg::string)::unicode
  def self.convert(arg)
    begin
      erg = ""                              # initialize erg
      arr = arg.split(" ")                  # "" wylie seperator
      arr.each do |s|
        if is_a_numeric?(s)
          erg = erg + convert_number(s)
        else
          if ["/",";"].include?(s)
            erg = erg + Lists.tuc(s)
          else
            erg = erg + convert_sylable(s)    # convert each sylable s in arr
          end
        end
      end #arr.each
    rescue
      erg = ""                              # empty result
    end
    return erg                              # [] for testing
  end #end convert



  # Converts single While sylable into unicode characters
  # convert_sylable(arg::string)::unicode
  def self.convert_sylable(arg)

    has_shad_result = has_shad(arg)
    shad = has_shad_result.at(0)
    if shad
      result = analysis(has_shad_result.at(3))
    else
      result = analysis(arg)
    end

    if result.length == 1                   # single character
      pre = result.at(0)                    # retuned as pre parameter
    else
      l = result.at(1).length
      if l == 1                             # simple root
        root = set_vowel(validate(result.at(1).join("")))
      else
        if l == 3                           # complex root
          root_partials = result.at(1)      # partials of root without vowel
          root = build_stack(root_partials) # unicode of root
          vowel = Lists.tuc(".#{validate(root_partials.at(2))}") # vowel of root
          root = root + vowel               # unicode of entire root
        end
      end #else
    end #else

    pre = set_vowel(result.at(0)) if result.at(0) != ""
    suffix = Lists.tuc(result.at(2)) if result.at(2) != ""
    suffix2 = Lists.tuc(result.at(3)) if result.at(3) != ""
    genitiv = set_vowel(result.at(4)) if validate(result.at(4)) != ""

    pre = validate(pre)
    root = validate(root)
    suffix = validate(suffix)
    suffix2 = validate(suffix2)
    genitiv = validate(genitiv)

    erg = pre + root + suffix + suffix2 + genitiv

    if erg != ""
      if shad
        if has_shad_result.at(1)
          erg = erg + Lists.tuc(".")
          erg = erg + Lists.tuc("/")
        else
          if not has_shad_result.at(2)
            erg = erg + Lists.tuc("/")
          end
        end
      else
        erg = erg + Lists.tuc(".")
      end #shad
    end

    return erg
  end #end convert_sylable



  private



  # quick and dirty workaround for returned nil
  # validate(arg::string|nil)::string
  def self.validate(arg)
    if arg == nil
      arg = ""
    end
    return arg
  end #end validate



  # because every string has an numeric value...
  # is_a_numeric?(arg::string)::unicode
  def self.is_a_numeric?(arg)
    num = ['0','1','2','3','4','5','6','7','8','9']
    num_arr = arg.split('')
    result = true
    num_arr.each do |elem|
      if not num.include?(elem)
        result = false
      end
    end
    return result
  end #end is_a_numeric?



  # convert cardinal numbers
  # convert_number(arg::string)::unicode
  def self.convert_number(arg)
    arr = arg.split('')
    result = ""
    arr.each do |elem|
      result = result + Lists.tuc(elem)
    end
    return result
  end #end convert_number



  # if arg has shad the sign before shad must not have a following tseg except 'nga'
  # has_shad searches for shad and the last letter. Sets thseg and shad if neccessary.
  # has_shad(arg::string)::array(4)[boolean,boolean,boolean,string]
  def self.has_shad(arg)
    shad = false
    ng = false
    g = false
    shad = arg.rindex('/') == arg.length-1  # is shad last character ?
    if shad
      new_arg = arg[0..arg.length-2]        # arg without the shad.rb
      ng = new_arg[new_arg.length-2..new_arg.length-1] == 'ng'
      g = new_arg[new_arg.length-1..new_arg.length-1] == 'g' && !ng
    end
    return [shad,ng,g,new_arg]
  end #end has_shad



  # Split single sylable into its partials
  # analysis(arg::string)::array(5)[pre, root, suffix, suffix2,genitiv]::unicode
  def self.analysis(arg)

    if Lists.letters(arg)                         # simple character (easiest case)
      erg = [arg]
    else
      result = g_point(arg)                 # does arg begins with g.y*... ?
      front = validate(result.at(0))        # [result]=[g.,y...]
      if front != ""
        arg = result.at(1)                  # arg=y...
      end

      result = genitiv(arg)                 # second vowel ? (e.g. genitiv)
      left = result.at(0)                   # at least left = arg
      if left != arg                        # no second vowel
        arg = left
        genitiv = result.at(1)              # set genitiv
      end

      result = split_after_root(arg)        # [result]=[prefix+root,suffixes]
      left = result.at(0)                   # [left]=[prefix+root]
      right = result.at(1)                  # [right]= [suffix1,suffix2]

      result = complex_root(left)           # search complex root

      if result != nil                      # root with super and/or subscript
        if result.at(0) != ""               # superscript exists
          indx = result.at(0)               # index to split at superscript
        else                                # subscript exists
          indx = result.at(1)               # index to split at subscript
        end
        tmp = arg.split(indx)
        pre = validate(tmp.at(0))           # vermeide nil !!!!!! notwendig???
        if pre != ""                        # prescript exists
          pre = pre + "a"                   # complete prescript with inherent 'a'
        end
        root = [result.at(0), result.at(1), result.at(2)]
      else                                  # single root exists
        result = simple_root(left)          # search simple root
        tmp = left.split(result)            # split root from left
        pre = validate(tmp.at(0))           # rest of left defines prefix

        if pre != ""                        # prefix exists
          pre = pre + "a"                   # complete prescript with inherent 'a'
        end
        root = [result]
      end

      result = set_suffix(right)            # get suffix1 and suffix2 from [right]
      suffix = result.at(0)                 # suffix1
      suffix2 = result.at(1)                # suffix2 (sa  only)

      if front != ""                        # case g.y*...
        pre = front                         # substitute 'g.' with 'ga'
      end

      erg = [pre, root, suffix, suffix2, genitiv]
    end

    return erg
  end #end analysis



  # g.y ==> g prescript of ya
  # g_point(arg::string)::array(2)[front, rest]::string
  def self.g_point(arg)
    front = ""                              # initialize prefix
    rest = arg
    if arg[0].chr == 'g' && arg[1].chr == '.' && arg[2].chr == 'y'
      front = "ga"                          # define front 'ga'
      rest = arg[2..arg.length-1]           # [rest]='y...'
    end
    return [front, rest]
  end #end g_point?



  # Splits at last vowel 'x
  # genitiv(arg::string)::array(2)[left ,validate(genitiv)]::string
  def self.genitiv(arg)
    left = arg
    if arg.count("aeiou") == 2 #count_vowels(arg) == 2               # second vowel exists
      right_indx = arg.rindex(/[']/)        # find rightmost position of 'x
      if right_indx == arg.length-2         # verify position
        left = arg[0..right_indx-1]         # define term without second vowel
        genitiv = arg[right_indx..arg.length-1] # definie genitiv
      end
    end
    return [left ,validate(genitiv)]
  end #end genitiv



  # counts vowels in arg and returns sum
  # count_vowels(arg::string)::integer
  def self.count_vowels(arg)
    a = arg.count("a")
    e = arg.count("e")
    i = arg.count("i")
    o = arg.count("o")
    u = arg.count("u")
    sum = a + e + i + o + u
  end #end count_vowels



  # split after vowel of root
  # split_after_root(arg::string)::array(2)[left, right]::string
  def self.split_after_root(arg)            # root ends with first vowel
    left = ""
    right = ""
    indx = arg.index(/[aeiou]/)             # index of first vowel
    if indx != nil                          # assumption : root-vowel found
      left = arg[0..indx]                   # root and preskript defines left
      right = arg[indx+1..arg.length]       # rest defines right
    else                                    # no (obvious) root exists
      left = arg                            # return arg for futher analysis
    end
    return [left, right]
  end #end simple_root



  # has complex root ?
  # complex_root(arg::string)::array(3)[sup, sub, vowel]::string|nil
  def self.complex_root(arg)                # arg including prefix and vowel
    result_sup = super_script(arg)          # define stack with superscript
    sup_indicator = result_sup.at(0)
    sup = result_sup.at(1)
    if sup_indicator                        # superscript exists
      tmp = arg.split(sup)                  # arg has no superscript
      arg = sup + tmp.at(tmp.length-1)      # stack with superscript (no prefix)
    end                 # (otherwise sub_script includes the prefix in analysis)
    result_sub = sub_script(arg)
    sub_indicator = result_sub.at(0)
    sub = result_sub.at(1)                  # define stack with subscript
    if not (sup_indicator || sub_indicator) # no superscript no subscript
      erg = nil                             # warum hier nil ??? REV
    else                                    # super- and/or subskript
      sup = "" if sup == nil                # sup leer wenn nil REV
      sub = "" if sub == nil                # sub leer wenn nil REV
      vowel = arg[arg.index(/[aeiou]/)].chr # Vokal definieren
      erg = [sup, sub, vowel]
    end
    return erg                              # returns array or nil
  end #end complex_root



  # has superscript ?
  # super_script(arg::string)::array(2)[indicator, res]::boolean,string
  def self.super_script(arg)
    sup = Lists.sup_stack_list              # needs array for traversing
    res = ""
    indicator = false
    sup.each do |s|
      res = arg[s]
      if res == s                           # superscript exists
        if res == "st"                      # case(st or sts)
          if "sts" == arg["sts"]
            res = "sts"
          end
        end
        if res == "rt"                      # case(rt or rts)
          if "rts" == arg["rts"]
            res = "rts"
          end
        end
        if res == "rd"                      # case(rd or rdz)
          if "rdz" == arg["rdz"]
            res = "rdz"
          end
        end
        indicator = true
        break                               # end after first hit
      end
    end
    return [indicator, res]
  end #end super_script



  # has Subscript ?
  # sub_script(arg::string)::array(2)[indicator, res]::boolean,string
  def self.sub_script(arg)                  # arg without superscript, with vowel
    sub = Lists.sub_stack_list              # needs array for traversing
    res = ""
    indicator = false
    sub.each do |s|
    res = arg[s]
      if res == s                           # subscript exists
        if res == "gr"                      # case(gr or grw)
          if "grw" == arg["grw"]
            res = "grw"
          end
        end
        indicator = true
        break                               # end after first hit
      end
    end
    return [indicator, res]
  end #end sub_script



  # find simple root
  # simple_root(arg::string)::unicode
  def self.simple_root(arg)
    prefix = ""
    root = ""
    root_arr = Array.new
    n = arg.length-1
    i = n
    while i > -1 do                         # begin search with last element in arg
      i = i-1
      root = arg[i..n]                      # search entire arg
      root_arr.push(root) if Lists.letters(root)  # add when in letters
    end
    return root_arr.at(root_arr.length-2)   # root is the second last element
  end #end simple_root



  # return comlete suffix1 and suffix2 (inherent a included)
  # set_suffix(arg::string)::array(2)[suffix, suffix2]::string
  def self.set_suffix(arg)
    suffix = ""
    suffix2 = ""
    if arg != nil && arg != ""              # suffix exists
      if arg.index(/[s]/) == arg.length-1   # last suffix is 'sa'
        suffix2 = "sa"                      # suffix2 only 'sa'
        if arg.length > 1                   # suffix2 exists
          suffix = arg[0..arg.length-2] + 'a' # define first suffix1
        end
      else                                  # suffix != 'sa' exists
        suffix = arg + 'a'                  # add inherent 'a'
      end
    end
    return [suffix, suffix2]
  end #end set_suffix



  # replace /eiou/ with 'a'
  # set_vowel(arg::string)::unicode
  def self.set_vowel(arg)
    ind = arg.index(/[eiou]/)               # search vowel x != 'a'
    if ind == arg.length-1                  # has to be last
      vokal = arg[ind].chr                  # read vowel
      zeichen = arg.sub(/[eiou]/, 'a')      # replace vowel with 'a'
      erg = Lists.tuc(zeichen) + Lists.tuc(".#{vokal}") # get unicode
    else                                    # no vowel != 'a' exists
      erg = Lists.tuc(arg)                  # return unicode of arg
    end
    return erg
  end # set_vowel



  # returns unicode of complex root
  # build_stack(arg::string)::unicode|""
  def self.build_stack(arg)
    has_super = arg.at(0) != ""         # boole for superscript
    has_sub = arg.at(1) != ""           # boole for subscript
    if has_super                        # superscript exists
      erg = Lists.stacks(arg.at(0))     # unicode of superstack
      if has_sub                        # Subskript existiert
        erg = erg + Lists.stacks_sub(arg.at(1)) # unicode of Subskript
      end
    else                                # NO superscript exists
      if has_sub                        # subscript exists
        erg = Lists.stacks(arg.at(1))   # unicode of subscript
      end
    end
    return validate(erg)
  end # build_stack


end # W2uconv
