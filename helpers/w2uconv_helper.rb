module W2uconvHelper

  def display(typ, id, content, font_size=140, pdng_left=0, pdng_right=1)
    output = ""
    output << "<#{typ} id=\"#{id}\" style=\"
                 font-size:#{font_size}%;
                 padding-left:#{pdng_left}em;
                 padding-right:#{pdng_right}em \">"
    output << content
    output << "</#{typ}>"
  end #end display

end #end W2uconvHelper
