class String
  def to_slug
    self.downcase.strip.gsub(/\s/, '_').gsub(/\W/, '')
  end
end