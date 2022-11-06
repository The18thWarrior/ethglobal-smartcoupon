from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import requests
import json
from pydantic import BaseModel

app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class EnrichmentData(BaseModel):
    email: str
    wallet_address: str


class CampaignData(BaseModel):
    contract_address: str
    method: str
    receiver_address: str


@app.get("/")
async def root():
    return "Alive"


@app.post("/enrich_user_data")
async def enrich_user_data(enrichment_data: EnrichmentData):
    url = "https://smartcoupon-dev-ed.develop.my.salesforce-sites.com/services/apexrest/SmartCoupon"
    data = {
        "address": enrichment_data.wallet_address,
        "email": enrichment_data.email,
        "linkedInURL": "linkedin.com/test",
        "twitter": "twitter.com/test",
        "discord": "discord.com/test",
    }
    headers = {"Content-type": "application/json", "Accept": "text/plain"}
    r = requests.post(url, data=json.dumps(data), headers=headers)
    print(str(data))
    return {"success": "OK"}


# @app.post("/campaign")
# async def campaign(campaign_data: Campaign):
