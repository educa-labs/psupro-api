
class RUTValidator < ActiveModel::Validator
  def validate(record)
    unless record.rut == ""
      run, dv = record.rut.split("-")
      unless run && dv
        record.errors[:rut] << 'invalid RUT'
        return
      end
      numbers = run.gsub(".","").split("").map{|x| x.to_i}.reverse
      series = (2...8).to_a
      suma = 0
      (0...numbers.length).each do |i|
        scaler = series[i%6]
        suma += scaler * numbers[i]
      end
      result = 11 - suma % 11
      unless (result.to_s == dv.strip) || (result == 10 && dv.strip== 'k') || (result == 11 && dv.strip =='0')
        record.errors[:rut] << 'invalid RUT'
      end
    end
  end
end