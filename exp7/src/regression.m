function [coeff_1, coeff_2, log_mse] = regression(x_data, y_data, x0)
    % parameters
    step_size = 1e-7;

    coeff_1 = x0(1);
    coeff_2 = x0(2);
    
    
    F = @(x,xdata)x(1)./((sin((xdata - x(2))*pi/180/2)).^4);
    
    [~, n] = size(x_data);
    
    log_mse = 0;
    for i = 1:n
        h = F(x0, x_data(i));
        y = y_data(i);
        log_mse = log_mse + log10(h) - log10(y);
    end
    
    
    
    for i = 1:25000
        grad_1 = 0;
        grad_2 = 0;
        
        for j = 1:n
            h = F([coeff_1, coeff_2], x_data(j));
            y = y_data(j);
            
            grad_1 = grad_1 + 2*(log10(h) - log10(y))/coeff_1;
            grad_2 = grad_2 + 2*(log10(h) - log10(y))*cot((x_data(j) - coeff_2)*pi/180/2)*(-2);
        end
        
        % coefficient update with gradients
        coeff_1 = coeff_1 - step_size*grad_1;
        coeff_2 = coeff_2 - step_size*grad_2;
        
        
        %{
        if(mod(i, 400) == 0)
            subplot(1, 2, i/400);
            t = linspace(min(x_data), max(x_data), 1000);
            plot(t, F([coeff_1, coeff_2], t));
            hold on;
            ylim([0 max(y_data)]);
            scatter(x_data, y_data);
        end
        %}
        
        % new log_mse
        log_mse = 0;
        for j = 1:n
            h = F([coeff_1, coeff_2], x_data(j));
            y = y_data(j);
            log_mse = log_mse + (log10(h) - log10(y))^2;
        end
        if(mod(i, 1000) == 0)
            %disp(sprintf("MSE: %.8f, A: %.8f, B: %.8f", log_mse, coeff_1, coeff_2));
        end
        
        if(log_mse < 0.01)
            break;
        end
    end
    
end