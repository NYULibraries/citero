module Citero
  require_relative 'citero/version'
  require_relative 'citero/csf'
  require_relative 'citero/inputs'
  require_relative 'citero/outputs'
  require_relative 'citero/utils'

  def self.from_formats
    [:csf, :openurl, :pnx]
  end

  def self.to_formats
    [:csf, :ris, :openurl, :bibtex, :easybib, :refworks_tagged]
  end

  def self.citation_styles
    []
  end

  def self.map(input)
    @input = input
    self
  end

  def self.from_(format)
    @from_format = format.to_sym
    self
  end

  def self.csf
    return nil unless @from_format
    case @from_format
      when :csf
        from = Citero::CSF.new(@input)
      when :openurl
        from = Citero::Inputs::OpenUrl.new(@input)
      when :pnx
        from = Citero::Inputs::PNX.new(@input)
      else
        raise ArgumentError
    end
    return from.csf
  end

  def self.to_(format)
    @to_format = format.to_sym

    case @from_format
      when :csf
        from = Citero::CSF.new(@input)
      when :openurl
        from = Citero::Inputs::OpenUrl.new(@input)
      when :pnx
        from = Citero::Inputs::PNX.new(@input)
      else
        raise ArgumentError
    end


    case @to_format
    when :ris
      return Citero::Outputs::RIS.new(from).to_ris
    when :openurl
      return Citero::Outputs::OpenUrl.new(from).to_openurl
    when :bibtex
      return Citero::Outputs::Bibtex.new(from).to_bibtex
    when :easybib
      return Citero::Outputs::EasyBib.new(from).to_easybib
    when :refworks_tagged
      return Citero::Outputs::RefworksTagged.new(from).to_refworks_tagged
    when :csf
      str = ""
      from.csf.to_s.each do |k,v|
        if v.kind_of?(Array)
          v.each do |va|
            str = "#{str}#{k}:#{va}\n"
          end
        else
          str = "#{str}#{k}:#{v}\n"
        end

      end
      return str
    end
  end

  def self.method_missing(method_sym, *arguments, &block)
    method_str = method_sym.to_s
    if (method_str.include? "to_")
      to_(method_str.split('_',2).last)
    elsif (method_str.include? "from_")
      from_(method_str.split('_',2).last)
    else
      super
    end
  end

  def self.respond_to?(method_sym, *arguments, &block)
    method_str = method_sym.to_s
    (method_str.include? "to_") || (method_str.include? "from_") || (method_str.eql? "csf") || super
  end
end