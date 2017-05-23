# frozen_string_literal: true

FactoryGirl.define do
  factory :tool, class: Tool do
    sequence(:title) { |n| "Outil #{n}" }
    association :tool_category # , factory: :patient
    axis Axis.order('random()').first
    group_size Tool.group_sizes.keys.first
    duration Tool.durations.keys.first
    level Tool.levels.keys.first
    teaser 'Résumé'
    description 'Description'
    goal 'Objectif'
    submitter_email 'truc@stuce.com'
  end
end
