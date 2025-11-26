# Import necessary libraries
import streamlit as st
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import pandas as pd
import plotly.express as px

# Setting page configuration
st.set_page_config(
    page_title="Spotify Playlist Analyzer",
    page_icon="🎵",
    layout="wide"
)

# Adding title and description
st.title("🎵 Spotify Playlist Analyzer")
st.markdown("Analyze audio features of tracks from any Spotify playlist.")


@st.cache_resource
def get_spotify_client():
    """Initialize and return Spotify client."""
    client_id = st.secrets["spotify_client_id"]
    client_secret = st.secrets["spotify_client_secret"]
    client_credentials_manager = SpotifyClientCredentials(
        client_id=client_id, client_secret=client_secret
    )
    return spotipy.Spotify(client_credentials_manager=client_credentials_manager)


@st.cache_data(ttl=3600)
def get_playlist_tracks(_sp, playlist_id):
    """Get the tracks from a playlist."""
    try:
        # Getting the tracks from the specified playlist
        playlist_tracks = _sp.playlist_tracks(playlist_id)
        playlist_info = _sp.playlist(playlist_id)

        # Extracting track details
        track_details = []
        for item in playlist_tracks['items']:
            track = item['track']
            if track is None:
                continue

            details = {}
            details['id'] = track['id']
            details['name'] = track['name']
            details['artist'] = track['artists'][0]['name']
            details['duration_ms'] = track['duration_ms']
            details['popularity'] = track['popularity']

            # Getting audio features for each track
            try:
                audio_features = _sp.audio_features(track['id'])[0]
                if audio_features:
                    details['danceability'] = audio_features['danceability']
                    details['energy'] = audio_features['energy']
                    details['key'] = audio_features['key']
                    details['loudness'] = audio_features['loudness']
                    details['mode'] = audio_features['mode']
                    details['speechiness'] = audio_features['speechiness']
                    details['acousticness'] = audio_features['acousticness']
                    details['instrumentalness'] = audio_features['instrumentalness']
                    details['liveness'] = audio_features['liveness']
                    details['valence'] = audio_features['valence']
                    details['tempo'] = audio_features['tempo']

                    track_details.append(details)
            except Exception as e:
                st.warning(f"Could not get audio features for track {track['name']}: {str(e)} "
                           f"[See this issue](https://stackoverflow.com/questions/79239871/cant-access-tracks-audio-features-using-spotipy-fetching-from-spotify-api)")

        # Converting to dataframe
        df = pd.DataFrame(track_details)

        # Adding duration in minutes
        try:
            df['duration_min'] = df['duration_ms'] / 60000
        except Exception as e:
            print(f"Could not convert duration to minutes: {str(e)}")
            
        return df, playlist_info['name']

    except Exception as e:
        st.error(f"Error fetching playlist: {str(e)}")
        return None, None


# Creating sidebar for input
st.sidebar.header("Settings")

# Adding expander for artist search test
with st.expander("🔍 Test Artist Search"):
    search_query = st.text_input("Artist Name", value="Linkin Park")
    if st.button("Search Artist"):
        try:
            sp_test = get_spotify_client()
            results = sp_test.search(q=search_query, type='artist', limit=5)
            artists = results['artists']['items']
            if artists:
                st.success(f"Found {len(artists)} artist(s)")
                for artist in artists:
                    st.write(f"**{artist['name']}**")
                    st.write(f"Followers: {artist['followers']['total']:,}")
                    st.write(f"Popularity: {artist['popularity']}")
                    if artist['genres']:
                        st.write(f"Genres: {', '.join(artist['genres'][:3])}")
                    st.divider()
            else:
                st.warning("No artists found")
        except Exception as e:
            st.error(f"Search error: {str(e)}")

# Adding playlist ID input
default_playlist = "3cEYpjA9oz9GiPac4AsH4n"
playlist_id = st.sidebar.text_input(
    "Spotify Playlist ID",
    value=default_playlist,
    help="Enter a Spotify playlist ID (e.g., 3cEYpjA9oz9GiPac4AsH4n for Spotify API Testing playlist)"
)

# Adding load button
if st.sidebar.button("Load Playlist", type="primary"):
    st.session_state['load_playlist'] = True

# Initializing Spotify client
sp = get_spotify_client()

# Loading and displaying playlist data
if playlist_id and st.session_state.get('load_playlist', False):
    with st.spinner("Loading playlist data..."):
        df, playlist_name = get_playlist_tracks(sp, playlist_id)

    if df is not None and not df.empty:
        st.header(f"📋 {playlist_name}")
        st.markdown(f"**{len(df)} tracks loaded**")

        # Creating tabs for different views
        tab1, tab2, tab3 = st.tabs(["📊 Data", "📈 Visualizations", "🔍 Analysis"])

        with tab1:
            # Displaying the dataframe
            st.subheader("Track Data")
            st.dataframe(
                df[['name', 'artist', 'popularity', 'duration_min', 
                    'danceability', 'energy', 'valence', 'tempo']],
                use_container_width=True,
                hide_index=True
            )

            # Adding download button
            csv = df.to_csv(index=False)
            st.download_button(
                label="Download CSV",
                data=csv,
                file_name=f"{playlist_name}_tracks.csv",
                mime="text/csv"
            )

        with tab2:
            col1, col2 = st.columns(2)

            with col1:
                # Creating scatter plot of energy vs danceability
                fig1 = px.scatter(
                    df,
                    x='danceability',
                    y='energy',
                    size='popularity',
                    color='valence',
                    hover_name='name',
                    title='Energy vs Danceability',
                    color_continuous_scale='RdYlGn'
                )
                st.plotly_chart(fig1, use_container_width=True)

            with col2:
                # Creating bar chart of audio features
                audio_features = ['danceability', 'energy', 'speechiness', 
                                  'acousticness', 'instrumentalness', 'liveness', 'valence']
                avg_features = df[audio_features].mean()
                fig2 = px.bar(
                    x=audio_features,
                    y=avg_features.values,
                    title='Average Audio Features',
                    labels={'x': 'Feature', 'y': 'Average Value'}
                )
                st.plotly_chart(fig2, use_container_width=True)

            # Creating histogram of tempo
            fig3 = px.histogram(
                df,
                x='tempo',
                nbins=20,
                title='Tempo Distribution',
                labels={'tempo': 'Tempo (BPM)', 'count': 'Number of Tracks'}
            )
            st.plotly_chart(fig3, use_container_width=True)

        with tab3:
            st.subheader("Playlist Statistics")

            # Creating metrics
            col1, col2, col3, col4 = st.columns(4)
            with col1:
                st.metric("Avg Popularity", f"{df['popularity'].mean():.1f}")
            with col2:
                st.metric("Avg Tempo", f"{df['tempo'].mean():.1f} BPM")
            with col3:
                st.metric("Avg Energy", f"{df['energy'].mean():.2f}")
            with col4:
                st.metric("Avg Danceability", f"{df['danceability'].mean():.2f}")

            # Adding top tracks by popularity
            st.subheader("Top 10 Most Popular Tracks")
            top_tracks = df.nlargest(10, 'popularity')[['name', 'artist', 'popularity']]
            st.dataframe(top_tracks, use_container_width=True, hide_index=True)

else:
    st.info("👈 Enter a Spotify playlist ID and click 'Load Playlist' to get started!")