class TrendChart

  def initialize(user)
    raise ArgumentError, 'user is null' if !user
    @user = user
  end

  def get_measure(measure, num_months)
      dat = user_measure_data(measure) || {}
      ret = {}
      Date.today.downto( num_months.months.ago.to_date).each do |day|
        d = day.to_s 
        ret[d] = dat[d]
      end
      {data: ret, name: user_measure_name(measure)}
  end

  def user_measure_data(measure)
    case measure
    when 'health'
      @user.chart_health
    when 'disease'
      @user.chart_disease
    when 'sleep'
      @user.chart_sleep
    when 'steps'
      @user.chart_steps
    when 'calories_out'
      @user.chart_calories_out
    else
      nil
    end
  end

  def user_measure_name(measure)
    case measure
    when 'health'
      'Health Today'
    when 'disease'
      'Disease Activity'
    when 'sleep'
      'Sleep'
    when 'steps'
      'Steps'
    when 'calories_out'
      'Calories Burned'
    else
      nil
    end
  end

end