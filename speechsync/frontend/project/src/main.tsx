import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import { AccuracyProvider } from "./context/AccuracyContext.tsx";
import "./index.css";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <AccuracyProvider>
      <App />
    </AccuracyProvider>
  </StrictMode>
);
