class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :idRedeSocial
  has_secure_password
  has_secure_token
   attr_accessible :register
   attr_accessor :register

  validates :email,
            :on => :create,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }

  def register_strategy strategy,user
    puts "+++++++++++++++++"
    puts 'Register strategy'
    register = Register.new(strategy,user)
    puts register.registed_user  
    return register.registed_user

  end


  # Gerador de chaves
  def generate_key(column)
    begin
      self[column] = SecureRandom.base64(4).gsub!(/[^0-9A-Za-z]/, '')
    end while User.exists?(column => self[column])
  end

  # Envia o email e salva o momento q foi enviado
  def send_password_reset
    generate_key(:password_reset_key)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver_now
  end

end
