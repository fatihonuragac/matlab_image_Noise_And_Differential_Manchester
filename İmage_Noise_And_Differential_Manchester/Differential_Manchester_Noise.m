%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                         %%
%%  Matlab programında Resim okunması ve görüntülenmesi    %%
%%                                                         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
kelime_uzunlugu=8;   % 8-bit/decimal number
L=kelime_uzunlugu-1:-1:0;
L=pow2(L); 
[A,map]=imread('autonom.jpg','jpg');
subplot(1,2,1); image(A); %axis equal tight;  % okunan dosyayi görüntüle
title('Gönderilen Resim')
dumy=[];
[m,n,q]=size(A);

for k=1:q,
for j=1:n,
    x=A(:,j,k);
    x=double(x);
    d=dec2bin(x,kelime_uzunlugu);   % okunan görüntü dosyasini binary diziye dönüstür
    d=1*d-48; % string den integer array formuna dönüsüm
    [m1,n1]=size(d);
    d_array1(j,k,:)=reshape(d,1,m1*n1); % Resmin bir kısmı bir diziye dönüştürüldü
end
end
d_array=reshape(d_array1,[1,6000*1812]); % Resim bir vektöre dönüştürüldü
    
% Farksal manchester hat kodlamsıyla kodlayalım
dm_array(1)=1;          % dm_array adında yeni dizi tanımlandı bu dizi hat kodlaması sonrası verileri tutacak olan dizi
dm_array(2)=-1;         % Dizinin ilk iki elemanı başlangıç için seçildi
for i=2:length(d_array)-1    % d_array dizisi içindeki bitlerin her birinin kontrolü için for döngüsü açıldı
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
end                                 % Farksal manchester hat kodlaması yapıldı

    % Gürültü ekleyelim
a=3.5;  
p_signal=var(dm_array(:));
p_noise= p_signal / 10^(a / 10);
noise = sqrt(p_noise)* randn(size(dm_array)) ;
gurultulu_resim = dm_array + noise;         % 3,5 dB gürültü eklendi

% Kodlanmış diziyi tersine çevirme işlemini yapalım
d_array(1)=1;
for u=3:2:length(gurultulu_resim)/2-1    % Hat kodlaması geri çevirilirken gürültülü olduğu için karar merceği 0 değeri olur  
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
end                         % Hat kodlaması bu sefer gürültülü bir şekilde tekrar geri bitlere çevrildi
d_array1=reshape(d_array,[604,3,6000]); % Vektör şeklindeki bitler tekrar matris haline dönüştürüldü
for k=1:q,
for j=1:n,
d=reshape(d_array1(j,k,:),m1,n1); % tekrar diziden matris haline dönüştürüldü   
B(:,j,k)=d*L'; % binary den desimale dönüstürerek tekrar yerine yaz
end
end

% Bu ikili döngü bittiğinde resmin tamamı işlenmiş olur.
% Elde edilen yeni resmi tekrar görüntüleyelim
B=uint8(B);
subplot(1,2,2); image(B);% axis equal tight;
title('Alınan Resim')

