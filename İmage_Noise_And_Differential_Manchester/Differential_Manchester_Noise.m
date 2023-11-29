%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                         %%
%%  Matlab program�nda Resim okunmas� ve g�r�nt�lenmesi    %%
%%                                                         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
kelime_uzunlugu=8;   % 8-bit/decimal number
L=kelime_uzunlugu-1:-1:0;
L=pow2(L); 
[A,map]=imread('autonom.jpg','jpg');
subplot(1,2,1); image(A); %axis equal tight;  % okunan dosyayi g�r�nt�le
title('G�nderilen Resim')
dumy=[];
[m,n,q]=size(A);

for k=1:q,
for j=1:n,
    x=A(:,j,k);
    x=double(x);
    d=dec2bin(x,kelime_uzunlugu);   % okunan g�r�nt� dosyasini binary diziye d�n�st�r
    d=1*d-48; % string den integer array formuna d�n�s�m
    [m1,n1]=size(d);
    d_array1(j,k,:)=reshape(d,1,m1*n1); % Resmin bir k�sm� bir diziye d�n��t�r�ld�
end
end
d_array=reshape(d_array1,[1,6000*1812]); % Resim bir vekt�re d�n��t�r�ld�
    
% Farksal manchester hat kodlams�yla kodlayal�m
dm_array(1)=1;          % dm_array ad�nda yeni dizi tan�mland� bu dizi hat kodlamas� sonras� verileri tutacak olan dizi
dm_array(2)=-1;         % Dizinin ilk iki eleman� ba�lang�� i�in se�ildi
for i=2:length(d_array)-1    % d_array dizisi i�indeki bitlerin her birinin kontrol� i�in for d�ng�s� a��ld�
    u=2*i-1;                
    if d_array(i)==0        
        if dm_array(u-1)==1
        dm_array(u)=-1;     
        dm_array(u+1)=1;
        else 
        dm_array(u)=1;
        dm_array(u+1)=-1;
        end                                 
    else 
            if dm_array(u-1)==1
            dm_array(u)=1;
            dm_array(u+1)=-1;
            else
            dm_array(u)=-1;
            dm_array(u+1)=1;
            end
    end
end                                 % Farksal manchester hat kodlamas� yap�ld�

    % G�r�lt� ekleyelim
a=3.5;  
p_signal=var(dm_array(:));
p_noise= p_signal / 10^(a / 10);
noise = sqrt(p_noise)* randn(size(dm_array)) ;
gurultulu_resim = dm_array + noise;         % 3,5 dB g�r�lt� eklendi

% Kodlanm�� diziyi tersine �evirme i�lemini yapal�m
d_array(1)=1;
for u=3:2:length(gurultulu_resim)/2-1    % Hat kodlamas� geri �evirilirken g�r�lt�l� oldu�u i�in karar merce�i 0 de�eri olur  
   i=(u+1)/2;                                                               
    if gurultulu_resim(u-1)>0 && gurultulu_resim(u)<0 && gurultulu_resim(u+1)>0
        d_array(i)=0;                   
    else if gurultulu_resim(u-1)<0 && gurultulu_resim(u)>0 && gurultulu_resim(u+1)<0
        d_array(i)=0;
    else if gurultulu_resim(u-1)>0 && gurultulu_resim(u)>0 && gurultulu_resim(u+1)>0
            d_array(i)=1;
    else if gurultulu_resim(u-1)<0 && gurultulu_resim(u)<0 && gurultulu_resim(u+1)>0
            d_array(i)=1;
    end
    end
    end
    end
end                         % Hat kodlamas� bu sefer g�r�lt�l� bir �ekilde tekrar geri bitlere �evrildi
d_array1=reshape(d_array,[604,3,6000]); % Vekt�r �eklindeki bitler tekrar matris haline d�n��t�r�ld�
for k=1:q,
for j=1:n,
d=reshape(d_array1(j,k,:),m1,n1); % tekrar diziden matris haline d�n��t�r�ld�   
B(:,j,k)=d*L'; % binary den desimale d�n�st�rerek tekrar yerine yaz
end
end

% Bu ikili d�ng� bitti�inde resmin tamam� i�lenmi� olur.
% Elde edilen yeni resmi tekrar g�r�nt�leyelim
B=uint8(B);
subplot(1,2,2); image(B);% axis equal tight;
title('Al�nan Resim')

