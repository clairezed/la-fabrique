# frozen_string_literal: true

namespace :db do
  desc 'Seeds database with dummy tools'
  task dummy_tools: :environment do
    generate_dummy_tools
  end
end

TITLES = [
  'Abigaïl', 'Avion de compétences', 'Fishbowl', 'Encore des mots', 'Rapport machin chose',
  'Active listening', 'The five whys', 'Diffusion Curve Reflection', 'Court',
  "Bien bien plus très long nom d'outil", 'Mash up innovation',
  'Exploring Client centricity', 'Tous ensemble'
].freeze

def generate_dummy_tools
  20.times { generate_dummy_tool }
end

def generate_dummy_tool
  tool = Tool.where(
    title: TITLES.sample,
    axis: Axis.order('random()').first,
    tool_category: ToolCategory.order('random()').first.id,
    group_size: Tool.group_sizes.keys.sample,
    duration: Tool.durations.keys.sample,
    level: Tool.levels.keys.sample,
    goal: 'Objectifs du machin',
    teaser: 'Résumé du bidule',
    description: "I should have known that you would have a perfect answer for me \
    (since most Ruby questions I browse here have your input somewhere). I am glad \
    you pointed out the versioning; I am using 1.9.2. apidock (mladen's comment) \
    does not have sample; neither does ruby-doc. In your opinion, what is the best \
    reference for Ruby, updated to 1.9?"
  ).first_or_create

  tool.accept! if tool.may_accept?
end
