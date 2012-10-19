%%% Find prediction equations/matrices given a fixed feedback loop%%% [Pc1,Pc2,Pc3,Pz1,Pz2,Pz3,Pr1,Pr2,Pr3] = ssmpc_predclp(A,B,C,D,K_fb,K_ff,N_c);%%%%%% Feedback loop is of the form%%%   u = -K_fb[x;d] + K_ff*r + c%%%%%%   z = [x;d]    are the estimates of x and the disturbance d%%%%%% Model is of the form%%%   x = Ax+Bu    y = Cx + Du + d  (assumes D=0)%%%%%%   N_c is the number of extra DOF c for constraint handling%%%%%% Predictions:%%%   x = Pc1*c + Pz1*z + Pr1*r%%%   u = Pc2*c + Pz2*z + Pr2*r%%%   y = Pc3*c + Pz3*z + Pr3*r%%%   e = r - y is predicted tracking error%%%   %%% Revision history:%%%   J.A. Rossiter (email: J.A.Rossiter@shef.ac.uk), original version, observor.m%%%   K.L. Davies, 12/3/09, renamed some variablesfunction [Pc1,Pc2,Pc3,Pz1,Pz2,Pz3,Pr1,Pr2,Pr3] = ssmpc_predclp(A,B,C,D,K_fb,K_ff,N_c);N_act = size(B,2);N_x = size(A,1);N_sen = size(C,1);K = K_fb(:,1:N_x);   K2 = K_fb(:,N_x+1:N_x+N_sen);Phi = A - B*K;Px1 = Phi; Px3 = C*Phi;P = Phi; P2 = eye(N_x);Pc1 = B;Pd1 = -B*K2;Pr1 = B*K_ff;Pc2 = eye(N_act);Pd2 = -K2;Pr2 = K_ff;Pc3 = C*B;Pd3 = C*B*K2;Pr3 = C*B*K_ff;Px2 = -K;for i=1:50;  Pc3 = [Pc3;C*P*B];  Pc2 = [Pc2;-K*P2*B];    vec = (i-1)*N_act+1:i*N_act;   Pd2 = [Pd2;Pd2(vec,:)+K*P2*B*K2];  Pr2 = [Pr2;Pr2(vec,:)-K*P2*B*K_ff];    vec = (i-1)*N_sen+1:i*N_sen;  Pd3 = [Pd3;Pd3(vec,:)+C*P*B*K2];  Pr3 = [Pr3;Pr3(vec,:)+C*P*B*K_ff];    Px2 = [Px2;-K*P];  Pc1 = [Pc1;P*B];   vec = (i-1)*N_x+1:i*N_x;  Pd1 = [Pd1;Pd1(vec,:)-P*B*K2];  Pr1 = [Pr1;Pr1(vec,:)+P*B*K_ff];    P = P*Phi;    Px1 = [Px1;P];  Px3 = [Px3;C*P];  P2 = P2*Phi;  endPz1 = [Px1,Pd1];Pz2 = [Px2,Pd2];Pz3 = [Px3,Pd3];nP = size(Pc1,1);nP2 = size(Pc2,1);nP3 = size(Pc3,1);for i=2:N_c;  vec = (i-1)*N_act+1:i*N_act;  vec2 = (i-1)*N_x+1:nP;  Pc1(vec2,vec) = Pc1(vec2-(i-1)*N_x,1:N_act);    vec2 = (i-1)*N_act+1:nP2;  Pc2(vec2,vec) = Pc2(vec2-(i-1)*N_act,1:N_act);    vec2 = (i-1)*N_sen+1:nP3;  Pc3(vec2,vec) = Pc3(vec2-(i-1)*N_sen,1:N_act);end            