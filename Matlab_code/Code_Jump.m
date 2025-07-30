% =================== Lastfall Sprung ===================
% --- Parameterdefinition ---
roh = 1025;                       % Dichte Wasser [kg/m^3]
A = 0.059;                        % Fläche Frontwing [m^2]
X_cop = 0.151;                    % Center of Pressure [m]
X_v = 0.0725;                     % Abstand Punkt A zum Mast [m]
X_h = 0.095;                      % Abstand Punkt B zum Mast [m]
X_ml = 0.8;                       % Fixierte Mastlänge [m]
v_vec = 0:0.5:10;                 % Geschwindigkeitsbereich [m/s]
C_vec = [1.5, 2.0, 2.5, 3.0];     % Slamming-Koeffizienten
linestyles = {'-', '--', ':', '-.'};

% --- Initialisierung ---
FAY_all = zeros(length(C_vec), length(v_vec));
FBY_all = zeros(length(C_vec), length(v_vec));

% --- Berechnung ---
for i = 1:length(C_vec)
    C = C_vec(i);
    for j = 1:length(v_vec)
        v = v_vec(j);
        FJ = C * roh * A * v^2;
        FAY = (FJ * (X_cop + X_h)) / (X_v + X_h);
        FBY = (-FJ * (X_cop - X_v)) / (X_v + X_h);
        FAY_all(i,j) = FAY;
        FBY_all(i,j) = FBY;
    end
end

% --- Plot: FAY mit grünem Hintergrund ---
figure;
subplot(2,1,1); hold on;

% Hintergrundfläche für Funktionsbereich
FAY_min = min(FAY_all(:)) * 0.9;
FAY_max = max(FAY_all(:)) * 1.1;
x_fill = [v_vec, fliplr(v_vec)];
y_fill = [FAY_max * ones(1, length(v_vec)), FAY_min * ones(1, length(v_vec))];
fill(x_fill, y_fill, [0.85 1 0.85], 'EdgeColor', 'none', ...
     'DisplayName', 'Funktionsbereich');

% FAY-Kurven
for i = 1:length(C_vec)
    plot(v_vec, FAY_all(i,:), linestyles{i}, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('C = %.1f', C_vec(i)));
end

xlabel('Geschwindigkeit /ms^{-1}');
ylabel('F_{ay} /N');
legend('Location', 'northwest');
ylim([FAY_min, FAY_max]);
xlim([0 10]);
%title('F_{ay} bei unterschiedlichen Slamming-Koeffizienten');
grid on;

% --- Plot: FBY mit Scharniergrenze ---
subplot(2,1,2); hold on;

% Scharniergrenze
grenze = -6000;
FBY_min = min(FBY_all(:)) * 1.1;
FBY_max = max(FBY_all(:)) * 1.1;
x_fill = [v_vec, fliplr(v_vec)];

% Grün: Funktionsbereich
y_fill_green = [grenze * ones(1, length(v_vec)), FBY_max * ones(1, length(v_vec))];
fill(x_fill, y_fill_green, [0.85 1 0.85], 'EdgeColor', 'none', ...
     'DisplayName', 'Funktionsbereich');

% Rot: Kritische Zone
y_fill_red = [FBY_min * ones(1, length(v_vec)), grenze * ones(1, length(v_vec))];
fill(x_fill, y_fill_red, [1 0.8 0.8], 'EdgeColor', 'none', ...
     'DisplayName', 'Kritische Zone');

% Scharnierlinie
plot(v_vec, grenze * ones(1, length(v_vec)), 'k--', 'LineWidth', 1.5, ...
     'DisplayName', 'Scharniergrenze -6000 N');

% FBY-Kurven
for i = 1:length(C_vec)
    plot(v_vec, FBY_all(i,:), linestyles{i}, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('C = %.1f', C_vec(i)));
end

xlabel('Geschwindigkeit /ms^{-1}');
ylabel('F_{by} /N');
legend('Location', 'best');
xlim([0 10]);
ylim([FBY_min, FBY_max]);
%title('F_{by} mit Scharniergrenze bei unterschiedlichen Slamming-Koeffizienten');
xticks(0:1:10); grid on;
