SELECT COUNT(*) AS total_rows
FROM spotify_daily_charts_tracks
RIGHT JOIN spotify_daily_charts_artists
    ON spotify_daily_charts_tracks.artist_id = spotify_daily_charts_artists.artist_id;

SELECT DISTINCT artist, track_name, 
SUM(streams) AS total_streams
FROM spotify_daily_charts
WHERE artist IN ('Up Dharma Down', 'Callalily', 'Gloc 9', 'Silent Sanctuary','Moonstar88')
GROUP BY artist, track_name
ORDER BY total_streams;

SELECT spotify_daily_charts_artists.artist_name AS artist,
    AVG(spotify_daily_charts_tracks.tempo) AS avg_tempo
FROM spotify_daily_charts_artists
JOIN spotify_daily_charts_tracks
    ON spotify_daily_charts_artists.artist_id = spotify_daily_charts_tracks.artist_id
GROUP BY spotify_daily_charts_artists.artist_name
ORDER BY avg_tempo DESC;

SELECT artist,
COUNT (DISTINCT date) AS count_in_top200
FROM spotify_daily_charts
WHERE position <200
GROUP BY artist
ORDER BY count_in_top200 DESC
LIMIT 5;

SELECT spotify_daily_charts.track_name,
    spotify_daily_charts_artists.artist_name,
    spotify_daily_charts_artists.popularity,
    AVG(spotify_daily_charts.streams) AS avg_streams
FROM spotify_daily_charts
JOIN spotify_daily_charts_artists
    ON spotify_daily_charts.artist= spotify_daily_charts_artists.artist_name
GROUP BY spotify_daily_charts.track_name,
    spotify_daily_charts_artists.artist_name,
    spotify_daily_charts_artists.popularity
ORDER BY avg_streams DESC;