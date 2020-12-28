%please star the repo if my work amazed you :)
clc
clear all
close all
%%%
M=2;% BPSK, QPSK, 16-QAM , 64-QAM , 256-QAM
N=1024; %% N point fft and ifft depends on it higher the N smoother will the pattern be

p_seed = [1,exp(-1),exp(-2)]; %pattern depends on it Try experimenting here
No_transmission=1000; %% No of OFDM symbols we send
    
data = zeros(N*No_transmission,1);


%% Convert bit stream into M-QAM word stream
for i=1:N*No_transmission
    data(i) = floor((rand * (M)))+1; %1 indexed// Note if data is not random the patterns do not emerge :(
end

%% M-QAM Serial to Parallel Block
if(M~=2)%not BPSK
    symb = zeros(sqrt(M),sqrt(M));
    symb_2 = zeros(sqrt(M),sqrt(M));
    
    symb_ordered=zeros(1,M);
    %Nearest symbol to 0 in +ve domain is (k,k) k i.e (symbol energy)^1/2  
    k = 1/sqrt(2);
    numbering = zeros(1,M);
    %Generate complex representation of M-QAM symbols
    for i=1:sqrt(M)
           for j=1:sqrt(M)
                symb(i,j) = ((i-1)*k - (sqrt(M)-1)*k/2) + ((j-1)*k - (sqrt(M)-1)*k/2)*1j;
                symb_2(i,j) = symb(i,j);%use it to verify numbering vs symbol
                numbering( (i-1)*sqrt(M)+ (j-1) + 1) = ((i-1)*sqrt(M)+ (j-1)) ;
                symb_ordered((j-1)*sqrt(M)+(i-1)+1)=symb(i,j);%this is what is seen in img 1->bottom left (M-1)->top right            
           end    
    end   
    
    %Convert M-QAM word stream to parallel stream with N M-QAM symbols in
    %parallel
    info_source = zeros(N, No_transmission);
    info_symb_index = zeros(N, No_transmission);
    
    for i=1:No_transmission
        for j=1:N
           info_source(j,i) = symb(data(j+(i-1)*N));%contains symbol 
           info_symb_index(j,i) = data(j+(i-1)*N) -1;%contains index of symbol 
        end
    end
    
    %plot M-QAM symbols
    numbering = numbering(:);
    symb = symb_ordered;
    symb_x = real(symb(:));
    symb_y = imag(symb(:));
    
    scatterplot(symb);
    b = num2str(numbering); c = cellstr(b);
    text(symb_x,symb_y, c);
    %plotting over
    

    
%% BPSK Serial to Parallel Block
else
    
    %%convert M-QAM word stream to parallel stream with N BPSK symbols in
    %parallel
    info_source = zeros(N, No_transmission);
    info_symb_index = zeros(N, No_transmission);
    
    for i=1:No_transmission
        for j=1:N
            if data(j+(i-1)*N) == 1
                info_source(j,i) = 1;
                info_symb_index(j,i) = 1;
            else
                info_source(j,i) = -1;
                info_symb_index(j,i) = 0;
            end
        end
    end
    
end



pattern = zeros(N, No_transmission);
p_seed_ifft = ifft(p_seed,N);
scatterplot(p_seed_ifft(:));
for i=1:No_transmission
    pattern(:,i) = info_source(:,i).*p_seed_ifft(:);
end

scatterplot(pattern(:));