close all
clear all

% Number samples in each frame
N = 256;

% Input files from primary mic and secondary mic
% For background music change the input files here to mic1_music.wav and
% mic2_music.wav
prim = 'mic1.wav';
seco = 'mic2.wav';
sample = 'cleanspeech.wav';

% Reading input files using audioread function
[mic1,fs1] = audioread(prim);
[mic2,fs2] = audioread(seco);
[clean,fs3 ] = audioread(sample);

% Finding length of each input signals, for inputs with music length is set
as 60,000 samples
l1 = length(mic1(1:60000));
l2 = length(mic2(1:60000));

% Finding the minimum value between two inputs
M = min(l1,l2);

% Calculations of number of frames
Nframes = fix(M/N);

% Setting the value of mu
mu = 0.002973;

% Initialization of variables
d = mic1;
x = mic2;
B = zeros(N,1);
Bs = zeros(N,Nframes(1,1));
E1 = [];
E2 = [];
E3 = [];
SNRbefore = [];
SNRafter = [];
SNRimp = 0;
SNRb = 0;
SNRa = 0;

% Calculation of E, B for each frame
for i = 1:Nframes
    n = (1:N)+(N*(i-1));

    % Peforming FFT operation
    X = fft(x(n));
    D = fft(d(n));

    % Converting elements X(w) into a diagonal matix
    Xdiag = diag(X);

    % Storing the values of B in a matrix
    Bs(:,i) = B;

    % Calculating the value of E for a frame
    E(:,i) = D - (Xdiag*B);
    B = B + (2*mu*Xdiag'*E(:,i));

    % Inverse Fourier Transform and storing it in matrix e with dimensions
    % Nframes x N
    e(i,:) = ifft(E(:,i));

    % Taking the magnitude squares for s(n), mic1(n), e(n)
    E1(i) = ((clean(n)')*clean(n))/N;
    E2(i) = ((mic1(n)')*mic1(n))/N;
    E3(i) = ((e(i,:))*e(i,:)')/N;

    % Calculation of SNR before and SNR after for each frame
    SNRbefore(i) = 10*log10((E1(i))/(E1(i)+E2(i)-(2*sqrt(E1(i)*E2(i)))));
    SNRafter(i) = 10*log10((E1(i))/(E1(i)+E3(i)-(2*sqrt(E1(i)*E3(i)))));
end

 % Calculation of Average SNR before ANC
 SNRb = mean(SNRbefore);

 % Calculation of Average SNR after ANC
 SNRa = mean(SNRafter);

 % Calculation of SNR improvement
 SNRimp = SNRa - SNRb;

 % Reshaping the matrix e into a column vector rs
 rs = reshape(ctranspose(e),[],1);

 % Audio after ANC
 sound(rs);

 % Dispalying SNR improvement in command window
 msg1 = sprintf('SNR improvement = %f dB',SNRimp);
 disp(msg1);

 % Plotting the convergence curve for E
 figure(1),
 plot(10*log10(E3));
 msg2 = sprintf('N = %d mu = %f',N,mu);
 title(msg2);
 xlabel('Frame Number');
 ylabel('|E| in dB');

 % Plotting the 3-D curve for B vs i and k for N = 128
 if N == 128
 Ba = abs(Bs);
 Ba = 10*log10(Ba);
 figure(2),
 mesh(Ba(1:64,1:468));
 xlabel('Frame Number(i)');
 ylabel('Frequency(k)');
 zlabel('|B(i,k)|^2 in dB');
 end
