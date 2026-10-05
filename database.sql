CREATE TABLE IF NOT EXISTS dahood_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    silent_aim BOOLEAN DEFAULT true,
    esp BOOLEAN DEFAULT true,
    fog_changer BOOLEAN DEFAULT true,
    head_invisibility BOOLEAN DEFAULT true,
    radius FLOAT DEFAULT 50.0,
    hitbox_expander BOOLEAN DEFAULT true,
    visibility FLOAT DEFAULT 1.0,
    UNIQUE KEY unique_player (player_id)
);

INSERT INTO dahood_settings (player_id, silent_aim, esp, fog_changer, head_invisibility, radius, hitbox_expander, visibility) VALUES
(1, true, true, true, true, 50.0, true, 1.0);