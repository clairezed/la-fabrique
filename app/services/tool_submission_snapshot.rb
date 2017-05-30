# frozen_string_literal: true

class ToolSubmissionSnapshot
  def initialize(tool)
    @tool = tool
  end

  def save
    @tool.touch(:submitted_at)
    json_tool = ToolHistorySerializer.new(@tool).as_json
    @tool.submitted_snapshot = json_tool
    @tool.save!
  end

end
