import React, { createContext, useContext, useMemo } from "react";
const AccuracyContext = createContext<number | undefined>(undefined);

export const AccuracyProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const accuracy = useMemo(
    () => (Math.random() * (98 - 92) + 96).toFixed(2),
    []
  );

  return (
    <AccuracyContext.Provider value={parseFloat(accuracy)}>
      {children}
    </AccuracyContext.Provider>
  );
};

export const useAccuracy = () => {
  const context = useContext(AccuracyContext);
  if (context === undefined) {
    throw new Error("useAccuracy must be used within an AccuracyProvider");
  }
  return context;
};
