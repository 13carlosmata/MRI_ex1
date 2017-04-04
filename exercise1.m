%%      1
gammabar = 42.58e6;
gamma = 2*pi*gammabar;
%%      2.1
%Imaging volume with a single manetization vector at (0,0) wit T1, T2 at 1e9
iv = ImagingVolume(0, 0, 1e9, 1e9);
plot(iv);   
%%      2.2
%Rectangular RF pulse, B=5.9uT f=42.58MHz phase=pi/2 pulse width= 1ms
rf = RectPulse(5.9e-6, 42.58e6, pi/2, 1e-3);
figure;
subplot(1,2,1);
plot (rf); title('Envelope function of the pulse','FontSize',18); 
subplot(1,2,2);
powspec(rf); title ('Envelope Power Spectrum of the pulse','FontSize',18);
%     2.3
% RF pulse to the IV with a B0 = 1.0T
seemri(iv,1.0,rf);
iv.toEquilibrium();
%%      4 
B0=1.0;
tp=10e-6;
angles=[0 pi/2 pi 3*pi/2];
angle = pi/2;
B1=angle/(gamma*tp);
f0=42.58e6;
ph=pi/2;
rf=SincPulse(B1,f0,0,tp);
%powspec(rf);
seemri(iv,B0,rf);
iv.toEquilibrium();
rf=SincPulse(B1,f0-0.6e6,pi/2,tp);
alpha = acos(iv.M(3)/norm(iv.M));
seemri(iv, B0, rf,'Plot',false);
iv.toEquilibrium();
% at 90°
dfs = [-1:0.1:1]*1e6;
alphas=[];
for i=dfs
    rf=SincPulse(B1,f0-i,0,tp);
    seemri(iv, B0, rf, 'Plot', false);
    alpha = acos(iv.M(3)/norm(iv.M));
    alphas=[alphas;alpha];
    iv.toEquilibrium();
end
figure;
subplot(1,2,1);
[FB1e, fs] = powspec(rf);
% graphing FFT
subplot(1,2,2);
plot(fs, abs(FB1e)/interp1(fs, abs(FB1e), 0), ...
dfs, alphas./(angle), 'o');
suptitle('Power Spectrum with Fourier Transform on the Envelope Function at flip angle= 90°');
iv.toEquilibrium();

% at 180°
angle = pi;
B1=angle/(gamma*tp);
rf=SincPulse(B1,f0,0,tp);

dfs = [-1:0.1:1]*1e6;
alphas=[];
for i=dfs
    rf=SincPulse(B1,f0-i,0,tp);
    seemri(iv, B0, rf, 'Plot', false);
    alpha = acos(iv.M(3)/norm(iv.M));
    alphas=[alphas;alpha];
    iv.toEquilibrium();
end
figure;
subplot(1,2,1);
[FB1e, fs] = powspec(rf);
% graphing FFT
subplot(1,2,2);
plot(fs, abs(FB1e)/interp1(fs, abs(FB1e), 0), ...
dfs, alphas./(angle), 'o');
suptitle('Power Spectrum with Fourier Transform on the Envelope Function at flip angle=180° ');














