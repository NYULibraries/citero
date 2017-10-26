require_relative "../lib/citero"

def pnx_data
<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<record>
  <display>
    <type>type-test</type>
    <publisher>publisher-test</publisher>
    <title>title-test</title>
    <creationdate>creationdate-test</creationdate>
    <language>language-test</language>
    <edition>edition-test</edition>
    <format>format-test</format>
    <identifier>identifier-test</identifier>
    <creator>creator-test</creator>
    <contributor>contributor-test</contributor>
    <description>description-test</description>
    <subject>subject-test</subject>
  </display>
  <addata>
    <pub>pub-test</pub>
    <cop>cop-test</cop>
    <issn>issn-test</issn>
    <eissn>eissn-test</eissn>
    <isbn>isbn-test</isbn>
    <date>date-test</date>
    <date>date-test</date>
    <jtitle>jtitle-test</jtitle>
    <addau>addau-test</addau>
  </addata>
  <enrichment>
    <classificationlcc>classificationlcc-test</classificationlcc>
  </enrichment>
  <control>
    <recordid>recordid-test</recordid>
  </control>
  <search>
    <subject>subject-test</subject>
    <creationdate>creationdate-test</creationdate>
  </search>
</record>

EOF
end

def pnx_data_book
<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<record>
  <display>
    <type>book</type>
    <publisher>publisher-test</publisher>
    <title>title-test</title>
    <creationdate>creationdate-test</creationdate>
    <language>language-test</language>
    <edition>edition-test</edition>
    <format>format-test</format>
    <identifier>identifier-test</identifier>
    <creator>creator-test</creator>
    <contributor>contributor-test</contributor>
    <description>description-test</description>
    <subject>subject-test</subject>
  </display>
  <addata>
    <pub>pub-test</pub>
    <cop>cop-test</cop>
    <issn>issn-test</issn>
    <eissn>eissn-test</eissn>
    <isbn>isbn-test</isbn>
    <date>date-test</date>
    <date>date-test</date>
    <jtitle>jtitle-test</jtitle>
    <addau>addau-test</addau>
  </addata>
  <enrichment>
    <classificationlcc>classificationlcc-test</classificationlcc>
  </enrichment>
  <control>
    <recordid>recordid-test</recordid>
  </control>
  <search>
    <subject>subject-test</subject>
    <creationdate>creationdate-test</creationdate>
  </search>
</record>

EOF
end
