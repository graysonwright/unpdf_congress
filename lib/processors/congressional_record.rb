

def minus(a, b)
    c = []
    a.each_with_index do |_, index|
        c << a[index] - b[index]
    end
    c
end

module Processors
  class CongressionalRecord
    def self.parse_pages(source)
      source.split(/^ *VerDate.+Jkt.+PO.+Frm.+Fmt.+Sfmt.+$/)
    end

    def self.clean_blank_lines(page)
      (page.split("\n") - [""]).join("\n")
    end

    def self.pull_tables(page)
      page.scan(/(?<=as follows:\n)[\w\-`:\s]+(?:.+\.{6,}.+\s+)+/).
        map.with_index {|table, index| [index, table.rstrip] }.to_h
    end
  end
end