% =================== Lift- & Drag-Kräfte  ===================

roh = 1025;                          % Dichte Wasser [kg/m^3]
A = 0.059;                           % Fläche Frontwing [m^2]
v_vec = 0:0.5:18;                    % Geschwindigkeit [m/s]

% --- Kurve „15 Grad“ ---
Cl_15 = 1.02;
Cd_15 = 0.25;
FL_15 = 0.5 * roh .* v_vec.^2 * Cl_15 * A;
FD_15 = 0.5 * roh .* v_vec.^2 * Cd_15 * A;

% --- Kurve „0 Grad“ ---
Cl_0 = 0.22;
Cd_0 = 0.025;
FL_0 = 0.5 * roh .* v_vec.^2 * Cl_0 * A;
FD_0 = 0.5 * roh .* v_vec.^2 * Cd_0 * A;

% --- Plot ---
y_min = min([FL_15, FD_15, FL_0, FD_0]) * 1.05;
y_max = max([FL_15, FD_15, FL_0, FD_0]) * 1.05;

figure; hold on;

% Verschiedene Farben und Linienstile
plot(v_vec, FL_15, '-',  'LineWidth', 1.5, 'DisplayName', 'F_L (15° Anstellwinkel)');
plot(v_vec, FD_15, '--', 'LineWidth', 1.5, 'DisplayName', 'F_D (15° Anstellwinkel)');
plot(v_vec, FL_0,  '-.', 'LineWidth', 1.5, 'DisplayName', 'F_L (0° Anstellwinkel)');
plot(v_vec, FD_0,  ':',  'LineWidth', 1.5, 'DisplayName', 'F_D (0° Anstellwinkel)');

xlabel('Geschwindigkeit /ms^{-1}');
ylabel('F /N');
legend('Location', 'northwest');
%title('Lastfall 1: Lift- und Dragkräfte bei 0° und 15° Anstellwinkel');
ylim([y_min y_max]);
xticks(0:2:18);
grid on;
