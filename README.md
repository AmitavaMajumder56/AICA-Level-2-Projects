# 📈 Real-Time Stock & Crypto Trend Predictor

A Streamlit dashboard that pulls **live NSE, BSE, global stock and crypto data**, cleans it,
scrapes company insights with **BeautifulSoup**, and forecasts trends with
**scikit-learn** models and an optional **TensorFlow LSTM**.

## Quick start (Windows)
1. Unzip the folder anywhere, e.g. `C:\StockPredictor`.
2. Double-click **`install_dependencies.bat`**. It will
   * find Python 3.9+ (or install Python 3.12 with winget if it's missing),
   * create a private virtual environment in `.venv`,
   * install everything from `requirements.txt`,
   * optionally install TensorFlow for the LSTM model,
   * run a self-test and offer to launch the app.
3. From then on, double-click **`run_app.bat`**. The dashboard opens at http://localhost:8501.

**Mac/Linux:** `python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && streamlit run app.py`

## What's inside
| Tab | Features |
|---|---|
| 📊 Market Dashboard | Live NIFTY 50, SENSEX, NIFTY BANK, NIFTY IT, S&P 500, NASDAQ cards; intraday and historical index charts; India-vs-global comparison; NIFTY 50 heat-map; top gainers and losers; market breadth; live NSE indices board and market status |
| 📈 Stock Analysis & Forecast | Pick any NIFTY 50 stock on NSE or BSE: candlestick + SMA + Bollinger + volume, RSI and MACD, return distribution, benchmark comparison, technical verdict, risk metrics, **pros and cons**, Screener.in pros/cons, ratios and shareholding, company profile, key metrics, **ML forecast**, financial statements, news with sentiment, CSV downloads |
| ₿ Crypto Tracker | Live board for 15 coins in INR or USD (1h/24h/7d change, 7-day sparklines) plus a full analysis and forecast for any coin |
| 🔍 Search Any Stock | Type a **company name or script code** (`Reliance`, `IRCTC`, `500325`, `Apple`, `TSLA`). You get the same full analysis, insights and forecast |
| ℹ️ About | Method, data sources and disclaimer |

## Data sources
* **Yahoo Finance** (`yfinance`): prices for `.NS` (NSE), `.BO` (BSE), indices, global stocks and crypto, plus fundamentals, financials and news
* **CoinGecko** public API: the live crypto board (falls back to Yahoo automatically)
* **NSE India**: live indices board and market status
* **BeautifulSoup scraping**: Screener.in (pros/cons, ratios, quarterly results, P&L, shareholding), Google Finance (quote and "about"), and Google News RSS (headlines)

## Machine learning
1. **Cleaning:** removes duplicates, normalises time zones, fills gaps, drops invalid prices, repairs High/Low and flags extreme moves.
2. **Features:** lagged returns, distance from moving averages, momentum, volatility, RSI, MACD and range position.
3. **Models:** Ridge, Random Forest, Gradient Boosting and an MLP neural net, plus LSTM if TensorFlow is installed. Each model is back-tested on the last 20% of data it never saw.
4. **Ensemble:** models are weighted by 1/RMSE. A 95% band comes from back-test errors, and a Random-Forest classifier gives P(next close higher).
5. **Honesty check:** every model is compared with a naive "tomorrow = today" baseline.

## Project layout
```
app.py                    Streamlit UI (5 tabs)
core/config.py            watch-lists, indices, crypto list, aliases
core/data_fetcher.py      Yahoo Finance / CoinGecko / symbol search
core/scraper.py           BeautifulSoup scrapers + NSE + headline sentiment
core/cleaning.py          OHLCV cleaning
core/indicators.py        SMA, EMA, RSI, MACD, Bollinger, ATR, OBV, risk stats
core/models.py            ML models, back-test, ensemble forecast
core/insights.py          technical verdict, pros/cons, key metrics, narrative
core/charts.py            Plotly charts
tests/test_offline.py     offline self-test (no internet needed)
```

## Troubleshooting
* **"DLL load failed ... An Application Control policy has blocked this file":** Windows Smart App Control (or a work/college IT policy) is blocking compiled Python library files. Run `install_dependencies.bat` again. It reinstalls long-established library versions and, if Windows still blocks them, opens Windows Security so you can turn **Smart App Control** off (*App & browser control → Smart App Control settings → Off*). On a managed laptop, ask IT to allow Python packages.
* **"Could not load enough price data":** Yahoo may be rate-limiting. Wait a minute, then press **🔄 Refresh** in the sidebar.
* **Screener / NSE sections missing:** those sites sometimes block automated requests. The rest of the app keeps working.
* **LSTM toggle greyed out:** TensorFlow isn't installed. Use Python 3.10 to 3.12, then run `.venv\Scripts\python -m pip install tensorflow`.

> ⚠️ Educational tool only, not investment advice. Consult a SEBI-registered adviser before investing.
