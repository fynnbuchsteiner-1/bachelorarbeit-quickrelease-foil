% =================== Lastfall Fahrt – Auftrieb/Widerstand ===================
% --- Parameterdefinition ---
roh = 1025;                          % Dichte Wasser [kg/m^3]
A = 0.059;                           % Fläche Frontwing [m^2]
Cl = 0.64;                           % Auftriebsbeiwert
Cd = 0.048;                          % Widerstandsbeiwert
X_cop = 0.151;                       % Center of Pressure [m]
X_v = 0.0725;                        % Abstand Punkt A zum Mast [m]
X_h = 0.095;                         % Abstand Punkt B zum Mast [m]
X_ml_vec = [0.6, 0.75, 0.9, 1.1];    % Mastlängen [m]
v_vec = 0:0.5:18;                    % Geschwindigkeitsbereich [m/s]
F_threshold = -360;                 % Auslösekraft [N]

linestyles = {'-', '--', ':', '-.', ':'};  % 5 unterscheidbare Linienarten

% --- Initialisierung ---
FAY_all = zeros(length(X_ml_vec), length(v_vec));
FBY_all = zeros(length(X_ml_vec), length(v_vec));

% --- Berechnung ---
for i = 1:length(X_ml_vec)
    X_ml = X_ml_vec(i);
    for j = 1:length(v_vec)
        v = v_vec(j);
        FD = 0.5 * roh * v^2 * Cd * A;
        FL = 0.5 * roh * v^2 * Cl * A;
        FAY = (FL * (X_cop + X_h) - FD * X_ml) / (X_v + X_h);
        FBY = (-FL * (X_cop - X_v) + FD * X_ml) / (X_v + X_h);
        FAY_all(i,j) = FAY;
        FBY_all(i,j) = FBY;
    end
end

% --- Plot: FAY ---
figure;
subplot(2,1,1); hold on;

% Bereichsfärbung mit Handles für Legende
y_max = max(FAY_all, [], 'all') + 100;
y_min = min(FAY_all, [], 'all') - 100;
ylim([y_min, y_max]);

% Grün oberhalb der Auslösegrenze (Funktionsbereich)
h_green = area(v_vec, y_max * ones(size(v_vec)), F_threshold, ...
    'FaceColor', [0.85 1 0.85], 'EdgeColor', 'none', ...
    'ShowBaseLine', 'off', 'DisplayName', 'Funktionsbereich');

% Linienplots
for i = 1:length(X_ml_vec)
    plot(v_vec, FAY_all(i,:), linestyles{i}, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('X_{ml} = %.2f m', X_ml_vec(i)));
end


xlabel('Geschwindigkeit /ms^{-1}');
ylabel('F_{ay} /N');
legend('Location', 'northwest');
grid on;
%title('F_{ay} bei verschiedenen Mastlängen');

% --- Plot: FBY ---
subplot(2,1,2); hold on;

% Bereichsfärbung komplett grün
y_max_fby = max(FBY_all, [], 'all') + 50;
y_min_fby = min(FBY_all, [], 'all') - 50;
ylim([y_min_fby, y_max_fby]);
h_green_fby = area(v_vec, y_max_fby * ones(size(v_vec)), y_min_fby, ...
    'FaceColor', [0.85 1 0.85], 'EdgeColor', 'none', ...
    'ShowBaseLine', 'off', 'DisplayName', 'Funktionsbereich');

% Linienplots
for i = 1:length(X_ml_vec)
    plot(v_vec, FBY_all(i,:), linestyles{i}, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('X_{ml} = %.2f m', X_ml_vec(i)));
end

xlabel('Geschwindigkeit /ms^{-1}');
ylabel('F_{by} /N');
legend('Location', 'northwest'); grid on;
%title('F_{by} bei verschiedenen Mastlängen');
