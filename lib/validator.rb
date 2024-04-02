require 'logger'

module Validator
    def logger
        @logger ||= Logger.new($stdout)
        @logger.level = Logger::INFO
        @logger
    end

    def calculate_digit_cpf(cpf, start)
        sum = 0
        start.downto(2) do |i|
            sum += cpf[start - i] * i
        end
        sum = (sum * 10) % 11
        sum == 10 ? 0 : sum
    end

    def calculate_digit_cnpj(cnpj, start)
        weights = (2..9).to_a.reverse + (2..(start - 8)).to_a.reverse
        sum = 0
        weights.each_with_index do |weight, index|
            sum += cnpj[index] * weight
        end
        sum = (sum * 10) % 11
        sum == 10 ? 0 : sum
    end

    def cpf_validator(cpf)
        logger.info("Starting CPF validation for #{cpf}")
        cpf = cpf.to_s.gsub(/[^0-9]/, '').chars.map(&:to_i)
        if cpf.length != 11
            logger.error("CPF length is not 11")
            return { valid: false, message: "Invalid CPF: wrong length" }
        end
        if cpf.uniq.length == 1
            logger.error("CPF is a sequence of the same digit")
            return { valid: false, message: "Invalid CPF: sequence of the same digit" }
        end
        
        first_digit = calculate_digit_cpf(cpf, 10)
        unless first_digit == cpf[9]
            logger.error("First verifying digit does not match")
            return { valid: false, message: "Invalid CPF: first verifying digit does not match" }
        end
    
        second_digit = calculate_digit_cpf(cpf, 11)
        if second_digit == cpf[10]
            logger.info("CPF is valid")
            return { valid: true, message: "Valid CPF" }
        else
            logger.error("Second verifying digit does not match")
            return { valid: false, message: "Invalid CPF: second verifying digit does not match" }
        end
    end

    def cnpj_validator(cnpj)
        logger.info("Starting CNPJ validation for #{cnpj}")
        cnpj = cnpj.to_s.gsub(/[^0-9]/, '').chars.map(&:to_i)
        if cnpj.length != 14
            logger.error("CNPJ length is not 14")
            return { valid: false, message: "Invalid CNPJ: wrong length" }
        end
        if cnpj.uniq.length == 1
            logger.error("CNPJ is a sequence of the same digit")
            return { valid: false, message: "Invalid CNPJ: sequence of the same digit" }
        end

        first_digit = calculate_digit_cnpj(cnpj, 12)
        unless first_digit == cnpj[12]
            logger.error("First verifying digit does not match")
            return { valid: false, message: "Invalid CNPJ: first verifying digit does not match" }
        end

        second_digit = calculate_digit_cnpj(cnpj, 13)
        if second_digit == cnpj[13]
            logger.info("CNPJ is valid")
            return { valid: true, message: "Valid CNPJ" }
        else
            logger.error("Second verifying digit does not match")
            return { valid: false, message: "Invalid CNPJ: second verifying digit does not match" }
        end
    end
end