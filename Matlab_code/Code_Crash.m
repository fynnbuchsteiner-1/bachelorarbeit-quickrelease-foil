% =================== Lastfall Crash ===================
% --- Parameterdefinition ---
g = 9.81;                                % Erdbeschleunigung [m/s^2]
roh = 1025;                              % Dichte Wasser [kg/m^3]
FAY_target = -360;                       % Magnet-Haltekraft [N]
X_hs = 0.955;                            % Schwerpunkt-Höhe Surfer [m]
X_lzl = 1.736;                           % Länge linker Zylinder [m]
X_rzl = 0.389;                           % Radius linker Zylinder [m]
m = 68.8;                                % Masse [kg]

A = 0.059;                               % Fläche Frontwing [m^2]
Cl = 1.02;                               % Auftriebsbeiwert
Cd = 0.25;                               % Widerstandsbeiwert

X_cop = 0.151;                           % Druckmittelpunkt [m]
X_v = 0.0725;                            % Abstand A zu Mastachse [m]
X_h = 0.095;                             % Abstand B zu Mastachse [m]
X_as = X_cop - X_v;                      % Abstand Surfer zu Punkt A [m]

X_ml_vec = [0.6, 0.75, 0.9, 1.1];  % Mastlängen [m]
v_vec = 0:0.5:18;                        % Geschwindigkeitsbereich [m/s]

% Farben und Linienstile
colors = lines(5);  % 5 verschiedene Farben
linestyles = {'-', '--', ':', '-.', '-'};  % 5 verschiedene Stile

% --- Initialisierung ---
Fay_all = zeros(length(X_ml_vec), length(v_vec));
Fby_all = zeros(length(X_ml_vec), length(v_vec));

% --- Berechnung ---
for j = 1:length(X_ml_vec)
    X_ml = X_ml_vec(j);
    for i = 1:length(v_vec)
        v = v_vec(i);
        a = X_as + X_v - X_cop;
        r = sqrt((X_ml + X_hs)^2 + a^2);
        alpha = asind(a / r);
        Phi = 0;
        Fg = m * g;
        Izl = (1/4) * m * X_rzl^2 + (1/12) * m * X_lzl^2;
        Iges = Izl + m * r^2;
        w = sqrt((m * v^2)/(Iges));
        Fz = m * w^2 * r;

        Fay = (-Fz * cosd(alpha) * (X_as + X_v + X_h) + Fz * sind(alpha) * X_hs + Fg * (X_as + X_v + X_h) * cosd(Phi)) / (X_v + X_h);
        Fby = (Fz * cosd(alpha) * X_as - Fz * sind(alpha) * X_hs - Fg * X_as * cosd(Phi)) / (X_v + X_h);

        Fay_all(j,i) = Fay;
        Fby_all(j,i) = Fby;
    end
end

% =================== Plot: Fay mit Magnet-Haltekraft ===================
figure; hold on;
FAY_min = min(Fay_all(:)) * 1.1;
FAY_max = max(Fay_all(:)) * 1.1;
x_fill = [v_vec, fliplr(v_vec)];
y_fill_red = [FAY_target * ones(1, length(v_vec)), FAY_max * ones(1, length(v_vec))];
fill(x_fill, y_fill_red, [1 0.8 0.8], 'EdgeColor', 'none', 'DisplayName', 'Kritische Zone');
y_fill_green = [FAY_min * ones(1, length(v_vec)), fliplr(FAY_target * ones(1, length(v_vec)))];
fill(x_fill, y_fill_green, [0.85 1 0.85], 'EdgeColor', 'none', 'DisplayName', 'Auslösebereich');

for j = 1:length(X_ml_vec)
    plot(v_vec, Fay_all(j,:), linestyles{j}, 'Color', colors(j,:), ...
        'LineWidth', 1.5, 'DisplayName', sprintf('X_{ml} = %.2f m', X_ml_vec(j)));
end
plot(v_vec, FAY_target * ones(1, length(v_vec)), 'k--', 'LineWidth', 1.5, ...
    'DisplayName', 'Magnet-Haltekraft -360 N');
xlabel('Geschwindigkeit /ms^{-1}');
ylabel('F_{ay} /N');
legend('Location', 'best');
xlim([0 18]); ylim([FAY_min FAY_max]);
xticks(0:2:18); grid on;

% =================== Plot: Fby mit Scharniergrenze ===================
figure; hold on;
FBY_min = min(Fby_all(:)) * 0.9;
FBY_max = max(Fby_all(:)) * 1.1;
y_fill_green = [6000 * ones(1, length(v_vec)), FBY_min * ones(1, length(v_vec))];
y_fill_red = [FBY_max * ones(1, length(v_vec)), 6000 * ones(1, length(v_vec))];
x_fill = [v_vec, fliplr(v_vec)];

fill(x_fill, y_fill_green, [0.85 1 0.85], 'EdgeColor', 'none', 'DisplayName', 'Funktionsbereich < 6000 N');
fill(x_fill, y_fill_red, [1 0.8 0.8], 'EdgeColor', 'none', 'DisplayName', 'Kritische Zone > 6000 N');
plot(v_vec, 6000 * ones(1, length(v_vec)), 'k--', 'LineWidth', 1.5, ...
    'DisplayName', 'Scharniergrenze 6000 N');

for j = 1:length(X_ml_vec)
    plot(v_vec, Fby_all(j,:), linestyles{j}, 'Color', colors(j,:), ...
        'LineWidth', 1.5, 'DisplayName', sprintf('X_{ml} = %.2f m', X_ml_vec(j)));
end
xlabel('Geschwindigkeit /ms^{-1}');
ylabel('F_{by} /N');
legend('Location', 'best');
xlim([0 18]); ylim([FBY_min FBY_max]);
xticks(0:2:18); grid on;
