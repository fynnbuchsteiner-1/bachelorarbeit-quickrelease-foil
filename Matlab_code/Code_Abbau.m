% ===================Lastfall Abbau ===================
% --- Parameterdefinition ---
g = 9.81;                              % Erdbeschleunigung [m/s^2]
roh = 1025;                            % Dichte Wasser [kg/m^3]
FAY_target = -360;                     % Zielwert F_ay [N]
X_hs = 0.955;                          % Schwerpunkt-Höhe Surfer [m]
X_lzl = 1.736;                         % Länge linker Zylinder für Trägheit [m]
X_rzl = 0.389;                         % Radius linker Zylinder für Trägheit [m]
m = 68.8;                              % Masse [kg]

A = 0.059;                             % Fläche Frontwing [m^2]
Cl = 1.02;                             % Auftriebsbeiwert
Cd = 0.25;                             % Widerstandsbeiwert

X_cop = 0.151;                         % Druckmittelpunkt [m]
X_v = 0.0725;                          % Abstand A zu Mastachse [m]
X_h = 0.095;                           % Abstand B zu Mastachse [m]

% --- Berechnung der Auslösekraft ---
X_ml_range = 0.6:0.01:1.1;                         % Mastlängenbereich
FAB_vec = -FAY_target * (X_v + X_h) ./ X_ml_range; % Auslösekraft
y_max = 110;                                       % Obere y-Grenze für grüne Fläche

% --- Plot ---
figure; hold on;

% Grün oberhalb der Kurve
x_fill = [X_ml_range, fliplr(X_ml_range)];
y_fill_green = [y_max * ones(1, length(FAB_vec)), fliplr(FAB_vec)];
fill(x_fill, y_fill_green, [0.85 1 0.85], 'EdgeColor', 'none', 'DisplayName', 'Auslöse Zone');

% Rot unterhalb der Kurve
y_fill_red = [FAB_vec, fliplr(zeros(1, length(FAB_vec)))];
fill(x_fill, y_fill_red, [1 0.8 0.8], 'EdgeColor', 'none', 'DisplayName', 'Kritische Zone');

% Kurve
plot(X_ml_range, FAB_vec, 'b-', 'LineWidth', 1.5, 'DisplayName', 'F_{ab}-Grenze');

% Achsenbeschriftung und Layout
xlabel('Mastlänge /m');
ylabel('F_{ab} /N');
legend('Location', 'northeast');
xlim([0.6 1.1]);
ylim([0 y_max]);
xticks(0.6:0.1:1.1);
grid on;

