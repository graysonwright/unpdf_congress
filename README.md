# UnPDF Congressional Legislation

It’s important to be able to have plain text versions of bills,
especially draft legislation.
Why?
Clean (non-PDF) versions can be compared against other iterations
to see what has changed and marked-up
so that you can easily make suggestions for improvements.
Unfortunately,
pre-introduction legislation is only made available to staff as a PDF,
which is hardly useful to anyone.
And sometimes even introduced legislation
is available first as a PDF and only later as XML.

What would be helpful is a tool that ingests PDFs of draft-legislation
and returns plain text.
But converting the PDF to text isn’t enough.
It also would need to remove the line numbers,
the headers (e.g. “F:\M13\ROYCE\ROYCE_005.XML” as well as the page numbers),
and the footers
(e.g. “F:\M13\ROYCE\ROYCE_005.XML f:\VHLC\022613\022613.176.xml (542138|23)”.
By clearing out this additional stuff,
you’re left with the text of the legislation only,
which can then be used in many ways.

## Run locally

* Make sure you have `ruby` installed on your system.
* Install the project's dependencies with
  `gem install bundler && bundle install`
* Run `bundle exec ruby process.rb`
  to parse all PDFs in the `example` directory.
  The script will place all output text files in the `output/` directory.

## Add Examples

All examples must go in the `examples/` directory,
be stored with the file extension `.pdf`.
