T=1;
m=40; %sampling rate as multiple of symbol rate
%discrete time representation of sine pulse
time_p = 0:T/m:T; %sampling times over duration of pulse
p = sin(pi*time_p); %samples of the pulse
%symbols to be modulated
ns=4;
X_avg=0;
no_avg=12; % number of outputs we want, to calculate the average
figure(1);
for i=1:1:no_avg
  % symbols=arrayfun(@custom_random,rand(ns,1));
  symbols = randomArray(4);
  %UPSAMPLE BY m
  nsymbols = length(symbols);%length of original symbol sequence
  nsymbols_upsampled = 1+(nsymbols-1)*m;%length of upsampled symbol sequence
  symbols_upsampled = zeros(nsymbols_upsampled,1);%
  symbols_upsampled(1:m:nsymbols_upsampled)=symbols;%insert symbols with spacing M
  %GENERATE MODULATED SIGNAL BY DISCRETE TIME CONVOLUTION
  u=conv(symbols_upsampled,p)';
  time_u = 0:T/m:((length(u)-1)*T)/m;
  ut=u.*cos(2*pi*10*time_u);
  [X,f,df]=contFT(ut,0,T/m,0.001);
  X_power=(abs(X).^2)/(ns*0.001);
  subplot(3,4,i);
  plot(f,X_power);
  %xlim([-5,5]);
  xlabel ("f in kHz");
  ylabel ("PSD(X)"); 
  grid();
  title(['PSD(X): ',mat2str(symbols)]);
  if(X_avg == 0)
    X_avg=X_power;
  else
    X_avg=X_avg+X_power;
  end
  end
X_avg=X_avg/no_avg;
print -dpng all_dspsd.png
%time_u = 0:T/m:((length(u)-1)*T)/m; %unit of time = symbol time T
%plot(time_u,u);
%plot(time_p,p);
figure(2);
plot(f,X_avg);
%xlim([-5,5]);
xlabel ("f in kHz");
ylabel ("PSD(X_average)"); 
grid();
title("Average of power spectral densities of DSB over multiple inputs");
%plot(freqHz,abs(X));

print -dpng mean_dspsd.png
