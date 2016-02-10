class League < ActiveRecord::Base
  has_many :fantasy_teams, dependent: :destroy
  has_many :draft_picks, dependent: :destroy

  enum roster_style: [:hymm, :beavers, :lewis]

  validates :size, presence: true, 
    numericality: {only_integer: true, greater_than_or_equal_to: 2}

  validates :name, uniqueness: true

  accepts_nested_attributes_for :fantasy_teams
  validates_associated :fantasy_teams

  def year
    created_at.year
  end

  ROSTER_INFO = {
    hymm: {
      size: 16,
      starters: {
        'QB'    =>  1,
        'RB'    =>  1,
        'WR'    =>  2,
        'FLEX|RB|WR' =>  1,
        'TE'    =>  1,
        'DEF'   =>  1,
        'K'     =>  1
      },
      limits: {
        'QB'    =>  9,
        'RB'    =>  10,
        'WR'    =>  11,
        'TE'    =>  9,
        'DEF'   =>  9,
        'K'     =>  9
      },
      minimums: {
        'QB'    =>  1,
        'RB'    =>  2,
        'WR'    =>  2,
        'TE'    =>  1,
        'DEF'   =>  1,
        'K'     =>  1
      }
    },
    beavers: {
      size: 14,
      starters: {
        'QB'  =>  1,
        'RB'  =>  2,
        'WR'  =>  2,
        'TE'  =>  1,
        'DEF' =>  1,
        'K'   =>  1
      },
      limits: {
        'QB'    =>  2,
        'RB'    =>  3,
        'WR'    =>  3,
        'TE'    =>  2,
        'DEF'   =>  2,
        'K'     =>  2
      },
      minimums: {
        'QB'    =>  2,
        'RB'    =>  3,
        'WR'    =>  3,
        'TE'    =>  2,
        'DEF'   =>  2,
        'K'     =>  2
      }
    },
    if_it_bleeds_you_can_kill_it: {
      size: 16,
      starters: {
        'QB'    =>  1,
        'RB'    =>  2,
        'WR'    =>  2,
        'TE'    =>  1,
        'FLEX|RB|WR|TE' =>  1,
        'DEF'   =>  1,
        'K'     =>  1
      },
      limits: {
        'QB'    =>  8,
        'RB'    =>  9,
        'WR'    =>  10,
        'TE'    =>  8,
        'DEF'   =>  8,
        'K'     =>  7
      },
      minimums: {
        'QB'    =>  1,
        'RB'    =>  2,
        'WR'    =>  2,
        'TE'    =>  1,
        'DEF'   =>  1,
        'K'     =>  1
      }
    }
  }

  def roster_info(key)
    ROSTER_INFO[roster_style.to_sym][key] 
  end

  def roster_size
    roster_info :size
  end


end
