require 'spec_helper'

describe TagRemover do
  describe ".process" do
    it "removes elements" do
      input = StringIO.new """
      <root>
        <remove>
          Some contents
        </remove>
        <remove >
        </remove >
      </root>
      """
      output = StringIO.new
      tags_to_remove = ['remove']

      TagRemover.process input, output, remove_tags: tags_to_remove

      expect(output.string).to eq """
      <root>
      </root>
      """
    end

    it "removes single tags" do
      input = StringIO.new """
      <root>
        <remove/>
        <remove />
        <remove/ >
        <remove / >
      </root>
      """
      output = StringIO.new
      tags_to_remove = ['remove']

      TagRemover.process input, output, remove_tags: tags_to_remove

      expect(output.string).to eq """
      <root>
      </root>
      """
    end

    it "keeps elements" do
      input = StringIO.new """
      <root>
        <keep>
        </keep>
      </root>
      """
      tags_to_remove = ['remove']

      output = StringIO.new

      TagRemover.process input, output, remove_tags: tags_to_remove

      expect(output.string).to eq input.string
    end

    it "is ok with doing nothing" do
      input = StringIO.new """
      <root>
      </root>
      """
      output = StringIO.new

      TagRemover.process input, output

      expect(output.string).to eq input.string
    end

    it "removes nested tags" do
      input = StringIO.new """
      <root>
        <remove>
          <remove>
          </remove>
        </remove>
      </root>
      """
      tags_to_remove = ['remove']
      output = StringIO.new

      TagRemover.process input, output, remove_tags: tags_to_remove

      expect(output.string).to eq """
      <root>
      </root>
      """
    end

    it "closes the streams" do
      input = StringIO.new "<root></root>"
      output = StringIO.new

      TagRemover.process input, output, close_streams: true

      expect(input).to be_closed
      expect(output).to be_closed
    end
  end
end
