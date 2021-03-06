class QuestionEdge < ActiveRecord::Base
  belongs_to :question_flow
  belongs_to :parent_question, class_name: "Question"
  belongs_to :child_question, class_name: "Question"

  include Authority::Abilities
  self.authorizer_name = "AdminAuthorizer"

  acts_as_dag_links node_class_name: 'Question', ancestor_id_column: 'parent_question_id', descendant_id_column: 'child_question_id'

  def self.build_edge(ancestor, descendant, condition = nil, qf_id = QuestionFlow.first.id)
    source = self::EndPoint.from(ancestor)
    sink = self::EndPoint.from(descendant)
    conditions = self.conditions_for(source, sink)
    conditions[:condition] = condition
    path = self.new(conditions)
    path.make_direct
    path.question_flow_id = qf_id
    path
  end




end


