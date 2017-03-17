module Citero
  require "wtf_logger"
  require_relative 'citero/version'
  require_relative 'citero/csf'
  require_relative 'citero/inputs'
  require_relative 'citero/outputs'
  require_relative 'citero/utils'

  def self.from_formats
    [:csf, :openurl, :pnx, :ris]
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
    @from_format = format
    self
  end

  def self.to_(format)
    @to_format = format.to_sym
    # binding.pry if @input.eql?"itemType: note"

    if format.eql? :csf
      return Citero::CSF.new(@input).csf.to_s.to_s
    end


    case @from_format
    when :csf
      from = Citero::CSF.new(@input)
    when :ris
      from = Citero::Inputs::RIS.new(@input)
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
