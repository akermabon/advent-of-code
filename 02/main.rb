rounds = File.read(File.dirname(__FILE__) + '/input.txt').gsub(' ', '').split("\n")

# A/X = ROCK
# B/Y = PAPER
# C/Z = SCISSORS

PICK_SCORES = {
  'X' => 1,
  'Y' => 2,
  'Z' => 3
}
MATCH_SCORES = {
  'AX' => 3,
  'AY' => 6,
  'AZ' => 0,
  'BX' => 0,
  'BY' => 3,
  'BZ' => 6,
  'CX' => 6,
  'CY' => 0,
  'CZ' => 3
}
EXPECTED_VALUES = {
  'X' => 0,
  'Y' => 3,
  'Z' => 6
}

def get_round(p1, expected_value)
  MATCH_SCORES.find { |key, value| key.start_with?(p1) && value == expected_value }.first
end

ACTUAL_ROUNDS = %w[A B C].reduce({}) do |hash, p1|
  %w[X Y Z].each { |p2| hash[[p1, p2].join] = get_round(p1, EXPECTED_VALUES[p2]) }
  hash
end

def match_score(round)
  match_score = MATCH_SCORES[round]
  pick_score = PICK_SCORES[round[1]]
  match_score + pick_score
end

def score_for_action(action)
  actual_round = ACTUAL_ROUNDS[action]
  match_score(actual_round)
end

def computed_score(rounds)
  rounds.map { |round| match_score(round) }.sum
end

def computed_score_with_action(rounds)
  rounds.map { |round| score_for_action(round) }.sum
end

# part 1
p computed_score(rounds)

# part 2
p computed_score_with_action(rounds)