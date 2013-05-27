class Hash

  def to_xml
    self.map do |k,v|
      if v.respond_to?(:to_xml)
        "<#{k}>#{v.to_xml}</#{k}>"
      elsif v.respond_to?(:map)
        v.map do |i|
          "<#{k}>#{i}</#{k}>"
        end.join('')
      else
        "<#{k}>#{v}</#{k}>"
      end
    end.join('')
  end

end